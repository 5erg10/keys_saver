import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

final authProvider = StateNotifierProvider.autoDispose<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(AuthState());
});

class AuthStateNotifier extends StateNotifier<AuthState> {

  AuthStateNotifier(super.state);

  final _auth = LocalAuthentication();

  void authenticate() async {

    // isDeviceSupported indica si el dispositivo es compatible consistemas de biometria
    // canCheckBiometrics indica que el dispositivo tiene sensores de biometria, pero no si tiene alguno configurado y activado
    final canAuthenticate = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

    // Devuelve una lista de sensores de biometria que el usuario tiene configurados y ativados
    final availableBiometrics = await _auth.getAvailableBiometrics();

    try {
      if (!canAuthenticate || availableBiometrics.isEmpty) {
        state = state.copyWith(haveBiometrics: false);
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
        state = state.copyWith(isAuth: isAuthenticate ? AuthStatus.authenticated : AuthStatus.cancelAuth);
      }
    } on PlatformException catch (e){
      if (e.code == auth_error.notAvailable) {
        state = state.copyWith(isAuth:  AuthStatus.cancelAuth);
      } else if (e.code == auth_error.notEnrolled) {
        state = state.copyWith(haveBiometrics: false);
      } else {
      }
    }
  }
}

enum AuthStatus { authenticated, notAuthenticated, cancelAuth }

class AuthState {
  AuthStatus isAuth;
  final bool haveBiometrics;

  AuthState({
    this.isAuth = AuthStatus.notAuthenticated,
    this.haveBiometrics = true
  });

  AuthState copyWith ({
    AuthStatus? isAuth,
    bool? haveBiometrics
  }) => AuthState(
    isAuth: isAuth ?? this.isAuth,
    haveBiometrics: haveBiometrics ?? this.haveBiometrics
  );
}

// class LocalAuth {
//   static final _auth = LocalAuthentication();

//   static Future<bool> _canAuthenticate() async => await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

//   static Future<bool> authenticate() async {
//     try {
//       if (! await _canAuthenticate()) return false;
//       return await _auth.authenticate(
//         localizedReason: 'Necesita autenticarse para acceder',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true
//         ),
//         authMessages: const [
//          AndroidAuthMessages(
//             signInTitle: 'Oops! Biometric authentication required!',
//             cancelButton: 'No thanks',
//           ),
//           IOSAuthMessages(
//             cancelButton: 'No thanks',
//           ),
//         ]
//       );
//     } on PlatformException catch (e){
//       if (e.code == auth_error.notAvailable) {
//         // Add handling of no hardware here.
//       } else if (e.code == auth_error.notEnrolled) {
//         // ...
//       } else {
//         // ...
//       }
//       // insert comment
//       return false;
//     }
//   } 
// }