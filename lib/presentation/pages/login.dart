import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:keys_saver/domain/entities/entities.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';
import 'package:keys_saver/presentation/widgets/widgets.dart';
import '../providers/providers.dart';

enum OnBoardSteps { noAuth, needPasskey, loading, needStoragePermmisions, noBiometrics }
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  bool completeLoginAndConfig = false;
  bool authChecked = false;
  bool showCreatePrivateKey = false;
  bool haveBiometrics = false;

  AppCredentials? userManualCredentials;

  OnBoardSteps step = OnBoardSteps.loading;

  DevicePermissionsController permissionsController = Get.find();

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
    final bool userSaved = haveBiometrics ? true : await Get.put(ManualCredentialsController()).saveUserCredentials(userManualCredentials!, privKey);
    if (mounted) {
      userSaved ? navigateToHome() : CustomSnackbar(context: context, text: 'Error al guardar datos de usuario', backGroundColor: Colors.red);
    }
  }

  void onPrivKeySubmit(String privKey) async  {
    removeFocus();
    final bool passkeySuccess = await Get.put(PassKeyController()).writeSec(privKey);
    if (mounted) {
      passkeySuccess ? saveUserCredentials(privKey) : CustomSnackbar(context: context, text: 'Error al guardar la key', backGroundColor: Colors.red);
    }
  }

  void requestStoragePermissions() {
    Get.put(DevicePermissionsController()).checkStoragePermission();
  }

  void checkPassKeyCreated() async {
    final recoverPassKey = await Get.put(PassKeyController()).readSec();
    if (recoverPassKey == null) {
      setState(() {
        step = OnBoardSteps.needPasskey;
      });
    } else {
      navigateToHome();
    }
  }

  void createManualCredentials(String user, String password) async {

    AppCredentials newUserCrendetials = AppCredentials(user: user, passW: password);

    final String? currentPassKey = await Get.put(PassKeyController()).readSec();
    
    setState(() {
      userManualCredentials = newUserCrendetials;
      if (currentPassKey != null) {
        navigateToHome();
      } else {
        step = OnBoardSteps.needPasskey;
      }
    });
  }

  void checkAuthStatus() async {

    final AuthState authStatus = await Get.put(BiometricAuth()).authenticate();
    final String? currentPassKey = await Get.put(PassKeyController()).readSec();
    final AppCredentials? currentCredentials = currentPassKey != null ? await Get.put(ManualCredentialsController()).recoverCredentials(currentPassKey) : null;

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

  void checkStoragePermissions() async {
    bool permissionsGranted = await Get.put( DevicePermissionsController()).checkStoragePermission();
    permissionsGranted ? checkAuthStatus() : setState(() => step = OnBoardSteps.needStoragePermmisions);
  }

  @override
  void initState() {
    super.initState();
    if (!authChecked) {
      checkStoragePermissions();
    }
  }

  Widget bodyContent() {
    switch (step) {
      case OnBoardSteps.loading:
        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: CustomLoading(label: 'cargando configuracion ...', textColor: Theme.of(context).primaryColor),
          ),
        );

      case OnBoardSteps.noBiometrics:
        return ManualCredentialsForm(userCredentials: userManualCredentials, onSubmit: createManualCredentials);

      case OnBoardSteps.noAuth:
        return Container();

      case OnBoardSteps.needPasskey:
        return PrivateKeyForm(onSubmit: onPrivKeySubmit);

      case OnBoardSteps.needStoragePermmisions:
        return RequestStoragePermissionsModal(onClick: requestStoragePermissions);
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
