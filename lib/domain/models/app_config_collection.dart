import 'package:isar/isar.dart';

part 'app_config_collection.g.dart';

@collection
class AppConfig {
  Id id = Isar.autoIncrement;
  bool enableConfigTheme;
  bool darkModeEnabled;

  AppConfig({
    required this.enableConfigTheme,
    required this.darkModeEnabled,
  });
}