import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/infrastructure/datasources/isar_datasource.dart';
import 'package:keys_saver/infrastructure/repository/isar_repository.dart';

final configParamsProvider = StateNotifierProvider.autoDispose<AppConfigNotifier, ConfigState>((ref) {
  return AppConfigNotifier(ConfigState(configData: AppConfig(darkModeEnabled: false, enableConfigTheme: true )));
});


class AppConfigNotifier extends StateNotifier<ConfigState> {

  final dataRepository = IsarRepository(IsarDatasource());

  AppConfigNotifier(super.state);

  void saveAppConfig(AppConfig config) async {
    await dataRepository.saveAppConfig(config);
    state = state.copyWith(
      configData: config
    );
  }

  void recoverAppConfig() async {
    final appConfig = await dataRepository.recoverAppConfig();
    state = state.copyWith(
      configData: appConfig ?? AppConfig(enableConfigTheme: false, darkModeEnabled: false)
    );
  }

}

class ConfigState {

  final AppConfig configData;

  ConfigState({
    required this.configData
  });

  ConfigState copyWith({
    AppConfig? configData
  }) => ConfigState(
    configData: configData ?? this.configData
  );
}

