
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