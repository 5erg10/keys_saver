import 'dart:io';

import 'package:isar/isar.dart';
import 'package:keys_saver/domain/datasorces/local_datasource.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/infrastructure/services/encrypter_services.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalDatasource {

  late Future<Isar> db;

  IsarDatasource() {
    db = openkeysDb();
  }

  Future<Isar> openkeysDb() async {

    final Directory dir = await getApplicationDocumentsDirectory();

    if ( Isar.instanceNames.isEmpty ) {
      return await Isar.open([ KeyValuesSchema, AppConfigSchema, AppCredentialsSchema ], inspector: true, directory: dir.path );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<List<KeyValues>> getSavedKeys() async {
    final isar = await db;
    return isar.keyValues.where().findAll();
  }

  @override
  Future<void> saveKey(KeyValues key) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.keyValues.putSync(KeyValues(titulo: key.titulo, user: key.user, passW: EncrypterService.encrypt(key.passW)));
    });
  }
  
  @override
  Future<void> removeKey(int keyId) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.keyValues.deleteSync(keyId);
    });
  }
  
  @override
  Future<void> updateKey(KeyValues key) async  {
    final isar = await db;
    final String originalPass = key.passW;
    isar.writeTxnSync(() {
      isar.keyValues.putSync(key..passW = EncrypterService.encrypt(key.passW));
    });
    key.passW = originalPass;
  }
  
  @override
  Future<AppConfig?> recoverAppConfig() async {
    final isar = await db;
    final data = await isar.appConfigs.where().findAll();
    return data.isEmpty ? null : data[0];
  }

  @override
  Future<void> saveAppConfig(AppConfig config) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.appConfigs.putSync(config);
    });
  }
  
  @override
  Future<AppCredentials?> recoverCredentias() async {
    final isar = await db;
    final data = await isar.appCredentials.where().findAll();
    return data.isEmpty ? null : data[0];
  }
  
  @override
  Future<void> saveCredentials(AppCredentials creds) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.appCredentials.putSync(creds);
    });
  }

  
}