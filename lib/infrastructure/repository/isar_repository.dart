import 'package:keys_saver/domain/datasorces/local_datasource.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/domain/repository/local_repository.dart';

class IsarRepository extends LocalRepository {

  final LocalDatasource dataSource;

  IsarRepository(this.dataSource);

  @override
  Future<List<KeyValues>> getSavedKeys(String ncrK) {
    return dataSource.getSavedKeys(ncrK);
  }

  @override
  Future<void> saveKey(KeyValues key, String ncrK) {
    return dataSource.saveKey(key, ncrK);
  }
  
  @override
  Future<void> removeKey(int keyId) {
    return dataSource.removeKey(keyId);
  }
  
  @override
  Future<void> updateKey(KeyValues key, String ncrK) {
    return dataSource.updateKey(key, ncrK);
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
  Future<AppCredentials?> recoverCredentias(String ncrK) {
   return dataSource.recoverCredentias(ncrK);
  }

  @override
  Future<void> saveCredentials(AppCredentials creds, String ncrK) {
    return dataSource.saveCredentials(creds, ncrK);
  }

}