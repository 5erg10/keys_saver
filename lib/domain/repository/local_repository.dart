import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';

abstract class LocalRepository {

  Future<void> saveKey(KeyValues key);

  Future<List<KeyValues>> getSavedKeys();

  Future<void> removeKey(int keyId);

  Future<void> updateKey(KeyValues key);

  Future<void> saveAppConfig(AppConfig config);

  Future<AppConfig?> recoverAppConfig();

  Future<void> saveCredentials(AppCredentials creds);

  Future<AppCredentials?> recoverCredentias();
}