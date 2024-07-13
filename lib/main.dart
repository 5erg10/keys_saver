import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/config/routers/main_router.dart';
import 'package:keys_saver/config/theme/theme.dart';
import 'package:keys_saver/presentation/providers/app_config_provider.dart';

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    
    final appConfig = ref.watch(configParamsProvider).configData;
    
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appConfig.enableConfigTheme && appConfig.darkModeEnabled ? darkTheme : lightTheme,
      darkTheme: appConfig.enableConfigTheme && !appConfig.darkModeEnabled ? lightTheme : darkTheme,
      routerConfig: statelessRouter
    );
  }
}
