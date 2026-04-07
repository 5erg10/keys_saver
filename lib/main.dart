import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/config/routers/main_router.dart';
import 'package:keys_saver/config/theme/theme.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/presentation/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterNativeSplash.remove();

  final container = ProviderContainer();
  await container.read(configParamsProvider.notifier).recoverAppConfig();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MainApp(),
  ));
}

class MainApp extends ConsumerWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppConfig appConfig = ref.watch(configParamsProvider).configData;
    final bool isDarkMode = PlatformDispatcher.instance.platformBrightness == Brightness.dark;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appConfig.enableConfigTheme
          ? appConfig.darkModeEnabled ? darkTheme : lightTheme
          : isDarkMode ? darkTheme : lightTheme,
      routerConfig: statelessRouter,
    );
  }
}
