import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/domain/entities/entities.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricNotifier extends StateNotifier<AuthState> {
  BiometricNotifier()
      : super(AuthState(isAuth: AuthStatus.notAuthenticated, haveBiometrics: false));

  final LocalAuthentication _auth = LocalAuthentication();

  Future<AuthState> authenticate() async {
    final canAuthenticate =
        await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    final availableBiometrics = await _auth.getAvailableBiometrics();

    try {
      if (!canAuthenticate || availableBiometrics.isEmpty) {
        state = state.copyWith(haveBiometrics: false);
      } else {
        final isAuthenticated = await _auth.authenticate(
          localizedReason: 'Necesita autenticarse para acceder',
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            stickyAuth: false,
            biometricOnly: true,
          ),
          authMessages: const [
            AndroidAuthMessages(
              signInTitle: 'Es necesaria autenticación biometrica',
              cancelButton: 'Cancelar',
            ),
            IOSAuthMessages(
              cancelButton: 'Cancelar',
            ),
          ],
        );
        state = state.copyWith(
          isAuth: isAuthenticated ? AuthStatus.authenticated : AuthStatus.cancelAuth,
          haveBiometrics: true,
        );
      }
      return state;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        state = state.copyWith(isAuth: AuthStatus.cancelAuth);
      } else if (e.code == auth_error.notEnrolled) {
        state = state.copyWith(haveBiometrics: false);
      }
      return state;
    }
  }
}

final biometricProvider = StateNotifierProvider<BiometricNotifier, AuthState>(
  (ref) => BiometricNotifier(),
);
