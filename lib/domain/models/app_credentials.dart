import 'package:isar/isar.dart';

part 'app_credentials.g.dart';

@collection
class AppCredentials {
  Id id = Isar.autoIncrement;
  String? user;
  String? passW;

  AppCredentials({
    this.user,
    this.passW,
  });
}