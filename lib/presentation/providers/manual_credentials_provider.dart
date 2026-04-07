import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/infrastructure/datasources/isar_datasource.dart';
import 'package:keys_saver/infrastructure/repository/isar_repository.dart';

class ManualCredentialsState {
  final AppCredentials? credentials;
  const ManualCredentialsState({this.credentials});
}

class ManualCredentialsNotifier extends StateNotifier<ManualCredentialsState> {
  ManualCredentialsNotifier() : super(const ManualCredentialsState());

  final _repository = IsarRepository(IsarDatasource());

  Future<AppCredentials?> recoverCredentials(String ncrK) async {
    final userCredentials = await _repository.recoverCredentias(ncrK);
    state = ManualCredentialsState(credentials: userCredentials);
    return userCredentials;
  }

  Future<bool> saveUserCredentials(AppCredentials creds, String ncrK) async {
    return _repository.saveCredentials(creds, ncrK);
  }
}

final manualCredentialsProvider =
    StateNotifierProvider<ManualCredentialsNotifier, ManualCredentialsState>(
  (ref) => ManualCredentialsNotifier(),
);
