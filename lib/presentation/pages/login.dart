import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/presentation/providers/app_config_provider.dart';
import 'package:keys_saver/presentation/providers/app_credentials_provider.dart';
import 'package:keys_saver/presentation/providers/local_auth_provider.dart';
import 'package:keys_saver/presentation/providers/sec_storage_provider.dart';
import 'package:keys_saver/presentation/widgets/private_key_form.dart';
import 'package:keys_saver/presentation/widgets/user_data_form.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  bool credentialsPassed = false;
  bool showCreatePrivateKey = false;

  void removeFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(configParamsProvider.notifier).recoverAppConfig();
    ref.read(secProvider.notifier).readSec();
    if (!credentialsPassed) {
      ref.read(authProvider.notifier).authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final passKey = ref.watch(secProvider).key;
    final userCredentials = ref.watch(credentialsProvider).credentials;
    final haveBiometrics = ref.watch(authProvider).haveBiometrics;
    final isAuthOk = ref.watch(authProvider).isAuth;

    // Comprueba las credenciales solo cuando arranca la app
    if (!credentialsPassed && passKey.isNotEmpty) {
      // comprueba si el usuario ha definido ya una provate key para la encriptacion
      if (!haveBiometrics) {
        ref.read(credentialsProvider.notifier).recoverCredentials(passKey);
      } else {
        if (isAuthOk == AuthStatus.authenticated) {
          setState(() {
            credentialsPassed = true;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.push('/');
          });
        }
        if (isAuthOk == AuthStatus.cancelAuth) {
          exit(0);
        }
      }
    }

    void onFormSubmit(String user, String passW) {
      setState(() {
        credentialsPassed = true;
      });
      if (userCredentials!.user!.isEmpty) {
        ref.read(credentialsProvider.notifier)
        .saveUserCredentials(userCredentials ..user = user ..passW = passW, passKey);
      }
      context.push('/');
    }

    void onPrivKeySubmit(String privKey) {
      ref.read(secProvider.notifier).writeSec(privKey);
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Keys Saver')
              .boldSubString('Keys', Theme.of(context).textTheme.bodyMedium!),
          bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 5.0),
              child: Divider(color: Theme.of(context).primaryColor))),
      body: GestureDetector(
        onTap: removeFocus,
        child: ListView(children: [
          Center(
              child: SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: 300.0,
            child: passKey.isEmpty
                ? PrivateKeyForm(onSubmit: onPrivKeySubmit)
                : userCredentials == null
                    ? Center(
                        child: SizedBox(
                            height: 200.0,
                            child: Column(
                              children: [
                                const Text('Comprobando credenciales'),
                                const SizedBox(height: 40.0),
                                LoadingAnimationWidget.discreteCircle(
                                  color: Theme.of(context).primaryColor,
                                  secondRingColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  thirdRingColor:
                                      Theme.of(context).primaryColor,
                                  size: 30.0,
                                ),
                              ],
                            )),
                      )
                    : UserDataForm(
                        userCredentials: userCredentials,
                        onSubmit: onFormSubmit
                      ),
          )),
        ]),
      ),
    );
  }
}
