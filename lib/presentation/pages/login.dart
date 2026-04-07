import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:keys_saver/domain/entities/entities.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/presentation/providers/providers.dart';
import 'package:keys_saver/presentation/widgets/widgets.dart';

enum OnBoardSteps { noAuth, needPasskey, loading, noBiometrics }

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {

  bool authChecked = false;
  bool haveBiometrics = false;

  AppCredentials? userManualCredentials;

  OnBoardSteps step = OnBoardSteps.loading;

  void removeFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  void navigateToHome() {
    if (mounted) context.push('/');
  }

  void saveUserCredentials(String privKey) async {
    final bool userSaved = haveBiometrics
        ? true
        : await ref.read(manualCredentialsProvider.notifier).saveUserCredentials(
              userManualCredentials!,
              privKey,
            );
    if (mounted) {
      if (userSaved) {
        navigateToHome();
      } else {
        CustomSnackbar(
          context: context,
          text: 'Error al guardar datos de usuario',
          backGroundColor: Colors.red,
        ).showSnackBar();
      }
    }
  }

  void onPrivKeySubmit(String privKey) async {
    removeFocus();
    final bool passkeySuccess = await ref.read(passKeyProvider.notifier).writeSec(privKey);
    if (mounted) {
      if (passkeySuccess) {
        saveUserCredentials(privKey);
      } else {
        CustomSnackbar(
          context: context,
          text: 'Error al guardar la key',
          backGroundColor: Colors.red,
        ).showSnackBar();
      }
    }
  }

  void checkPassKeyCreated() async {
    final recoverPassKey = await ref.read(passKeyProvider.notifier).readSec();
    if (recoverPassKey == null) {
      setState(() => step = OnBoardSteps.needPasskey);
    } else {
      navigateToHome();
    }
  }

  void createManualCredentials(String user, String password) async {
    final AppCredentials newUserCredentials = AppCredentials(user: user, passW: password);
    final String? currentPassKey = await ref.read(passKeyProvider.notifier).readSec();

    setState(() {
      userManualCredentials = newUserCredentials;
      if (currentPassKey != null) {
        navigateToHome();
      } else {
        step = OnBoardSteps.needPasskey;
      }
    });
  }

  void checkAuthStatus() async {
    final AuthState authStatus = await ref.read(biometricProvider.notifier).authenticate();
    final String? currentPassKey = await ref.read(passKeyProvider.notifier).readSec();
    final AppCredentials? currentCredentials = currentPassKey != null
        ? await ref.read(manualCredentialsProvider.notifier).recoverCredentials(currentPassKey)
        : null;

    haveBiometrics = authStatus.haveBiometrics;

    if (!haveBiometrics) {
      setState(() {
        userManualCredentials = currentCredentials;
        step = OnBoardSteps.noBiometrics;
      });
    } else {
      authChecked = authStatus.isAuth == AuthStatus.authenticated;
      currentPassKey == null ? checkPassKeyCreated() : navigateToHome();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!authChecked) {
      checkAuthStatus();
    }
  }

  Widget bodyContent() {
    switch (step) {
      case OnBoardSteps.loading:
        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: CustomLoading(
              label: 'cargando configuracion ...',
              textColor: Theme.of(context).primaryColor,
            ),
          ),
        );

      case OnBoardSteps.noBiometrics:
        return ManualCredentialsForm(
          userCredentials: userManualCredentials,
          onSubmit: createManualCredentials,
        );

      case OnBoardSteps.noAuth:
        return const SizedBox.shrink();

      case OnBoardSteps.needPasskey:
        return PrivateKeyForm(onSubmit: onPrivKeySubmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: removeFocus,
        child: bodyContent(),
      ),
    );
  }
}
