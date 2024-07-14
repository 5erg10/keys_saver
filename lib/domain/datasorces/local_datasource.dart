import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';

abstract class LocalDatasource {

  Future<void> saveKey(KeyValues key, String ncrK);

  Future<List<KeyValues>> getSavedKeys(String ncrK);

  Future<void> removeKey(int keyId);

  Future<void> updateKey(KeyValues key, String ncrK);

  Future<void> saveAppConfig(AppConfig config);

  Future<AppConfig?> recoverAppConfig();

  Future<void> saveCredentials(AppCredentials creds, String ncrK);

  Future<AppCredentials?> recoverCredentias(String ncrK);
  
}