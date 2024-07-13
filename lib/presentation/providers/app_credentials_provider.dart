import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/infrastructure/datasources/isar_datasource.dart';
import 'package:keys_saver/infrastructure/repository/isar_repository.dart';

final credentialsProvider = StateNotifierProvider.autoDispose<CredentialsNotifier, CredentialsState>((ref) {
  return CredentialsNotifier(CredentialsState());
});

class CredentialsNotifier extends StateNotifier<CredentialsState> {

  final dataRepository = IsarRepository(IsarDatasource());

  CredentialsNotifier(super.state);

  void recoverCredentials() async {

    final userCredentials = await dataRepository.recoverCredentias();

    if (userCredentials == null) {
      final AppCredentials userDefault = AppCredentials(user: '', passW: '', passKey: '');
      saveUserCredentials(userDefault);
      state = state.copyWith(credentials: userDefault);
    } else {
      state = state.copyWith(credentials: userCredentials);
    }
  }

  void saveUserCredentials(AppCredentials creds) {
    dataRepository.saveCredentials(creds);
    recoverCredentials();
  }
}

class CredentialsState {

  final AppCredentials? credentials;

  CredentialsState({
    this.credentials
  });

  CredentialsState copyWith({
    AppCredentials? credentials
  }) => CredentialsState(
    credentials: credentials ?? this.credentials
  );
}