import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keys_saver/domain/entities/entities.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricAuth extends GetxController {

  final LocalAuthentication _auth = LocalAuthentication();

  AuthState authState = AuthState(isAuth: AuthStatus.notAuthenticated, haveBiometrics: false);

  Future<AuthState> authenticate() async {

    // isDeviceSupported indica si el dispositivo es compatible consistemas de biometria
    // canCheckBiometrics indica que el dispositivo tiene sensores de biometria, pero no si tiene alguno configurado y activado
    final canAuthenticate = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

    // Devuelve una lista de sensores de biometria que el usuario tiene configurados y ativados
    final availableBiometrics = await _auth.getAvailableBiometrics();

    try {
      if (!canAuthenticate || availableBiometrics.isEmpty) {
        authState = authState.copyWith(haveBiometrics: false);
      } else {
        final isAuthenticate = await _auth.authenticate(
          localizedReason: 'Necesita autenticarse para acceder',
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            stickyAuth: false,
            biometricOnly: true
          ),
          authMessages: const [
            AndroidAuthMessages(
              signInTitle: 'Es necesaria autenticación biometrica',
              cancelButton: 'Cancelar',
            ),
            IOSAuthMessages(
              cancelButton: 'Cancelar',
            ),
          ]
        );
        authState = authState.copyWith(isAuth: isAuthenticate ? AuthStatus.authenticated : AuthStatus.cancelAuth, haveBiometrics: true);
      }
      update();
      return authState;
    } on PlatformException catch (e){
      if (e.code == auth_error.notAvailable) {
        authState = authState.copyWith(isAuth:  AuthStatus.cancelAuth);
      } else if (e.code == auth_error.notEnrolled) {
        authState = authState.copyWith(haveBiometrics: false);
      } else {
      }
      update();
      return authState;
    }
  }
}