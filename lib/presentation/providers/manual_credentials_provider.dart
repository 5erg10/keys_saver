import 'package:get/get.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/infrastructure/datasources/isar_datasource.dart';
import 'package:keys_saver/infrastructure/repository/isar_repository.dart';

class ManualCredentialsController extends GetxController {

  final dataRepository = IsarRepository(IsarDatasource());

  AppCredentials? credentials;

  Future<AppCredentials?> recoverCredentials(String ncrK) async {
    final userCredentials = await dataRepository.recoverCredentias(ncrK);
    credentials = userCredentials;
    update();
    return credentials;
  }

  Future<bool> saveUserCredentials(AppCredentials creds, String ncrK) async {
    final bool success = await dataRepository.saveCredentials(creds, ncrK);
    return success;
  }
}