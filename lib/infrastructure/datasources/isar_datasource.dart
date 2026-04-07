import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:keys_saver/domain/datasources/local_datasource.dart';
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
      return await Isar.open([ KeyValuesSchema, AppConfigSchema, AppCredentialsSchema ], inspector: kDebugMode, directory: dir.path );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<List<KeyValues>> getSavedKeys(String ncrK) async {
    final isar = await db;

    final List<KeyValues> keysList = await isar.keyValues.where().findAll();

    for (final key in keysList) {
      key.passW = EncrypterService.decrypt(key.passW, ncrK);
      key.user = EncrypterService.decrypt(key.user, ncrK);
      key.titulo = EncrypterService.decrypt(key.titulo, ncrK);
    }

    return keysList;
  }

  @override
  Future<void> saveKey(KeyValues key, String ncrK) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.keyValues.putSync(
        KeyValues(
          titulo: EncrypterService.encrypt(key.titulo, ncrK),
          user: EncrypterService.encrypt(key.user, ncrK),
          passW: EncrypterService.encrypt(key.passW, ncrK)
        )
      );
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
  Future<void> updateKey(KeyValues key, String ncrK) async  {
    final isar = await db;
    final String originalPass = key.passW;
    isar.writeTxnSync(() {
      isar.keyValues.putSync(
        key
        ..passW = EncrypterService.encrypt(key.passW, ncrK)
        ..titulo = EncrypterService.encrypt(key.titulo, ncrK)
        ..user = EncrypterService.encrypt(key.user, ncrK)
    );
    });
    key.passW = originalPass;
  }
  
  @override
  Future<AppConfig?> recoverAppConfig() async {
    final isar = await db;
    return isar.appConfigs.where().findFirst();
  }

  @override
  Future<void> saveAppConfig(AppConfig config) async {
    final isar = await db;
    final existing = await isar.appConfigs.where().findFirst();
    AppConfig toSave;
    if (existing != null) {
      existing.darkModeEnabled = config.darkModeEnabled;
      existing.enableConfigTheme = config.enableConfigTheme;
      toSave = existing;
    } else {
      toSave = config;
    }
    isar.writeTxnSync(() => isar.appConfigs.putSync(toSave));
  }
  
  @override
  Future<AppCredentials?> recoverCredentias(String ncrK) async {

    final isar = await db;

    final List<AppCredentials> data = await isar.appCredentials.where().findAll();

    if (data.isEmpty) {
      return null;
    } else {
      return data[0]
        ..passW = EncrypterService.decrypt(data[0].passW!, ncrK)
        ..user = EncrypterService.decrypt(data[0].user!, ncrK);
    }
  }
  
  @override
  Future<bool> saveCredentials(AppCredentials creds, String ncrK) async {
    try {
      final isar = await db;
      final encryptedCreds =  creds
          ..passW = EncrypterService.encrypt(creds.passW!, ncrK)
          ..user = EncrypterService.encrypt(creds.user!, ncrK);
        
      isar.writeTxnSync(() {
        isar.appCredentials.putSync(encryptedCreds);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  
}