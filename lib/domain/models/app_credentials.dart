import 'package:isar/isar.dart';

part 'app_credentials.g.dart';

@collection
class AppCredentials {
  Id id = Isar.autoIncrement;
  String? user;
  String? passW;
  String? passKey;

  AppCredentials({
    this.user,
    this.passW,
    this.passKey
  });
}