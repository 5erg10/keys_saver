import 'package:keys_saver/domain/datasorces/local_datasource.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/domain/repository/local_repository.dart';

class IsarRepository extends LocalRepository {

  final LocalDatasource dataSource;

  IsarRepository(this.dataSource);

  @override
  Future<List<KeyValues>> getSavedKeys() {
    return dataSource.getSavedKeys();
  }

  @override
  Future<void> saveKey(KeyValues key) {
    return dataSource.saveKey(key);
  }
  
  @override
  Future<void> removeKey(int keyId) {
    return dataSource.removeKey(keyId);
  }
  
  @override
  Future<void> updateKey(KeyValues key) {
    return dataSource.updateKey(key);
  }
  
  @override
  Future<AppConfig?> recoverAppConfig() {
    return dataSource.recoverAppConfig();
  }

  @override
  Future<void> saveAppConfig(AppConfig config) {
    return dataSource.saveAppConfig(config);
  }

  @override
  Future<AppCredentials?> recoverCredentias() {
   return dataSource.recoverCredentias();
  }

  @override
  Future<void> saveCredentials(AppCredentials creds) {
    return dataSource.saveCredentials(creds);
  }

}