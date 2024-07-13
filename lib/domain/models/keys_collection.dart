import 'package:isar/isar.dart';

part 'keys_collection.g.dart';

@collection
class KeyValues {
  Id id;
  String titulo;
  String user;
  String passW;

  KeyValues({
    this.id = Isar.autoIncrement,
    required this.titulo,
    required this.user,
    required this.passW
  });

  KeyValues copyWith({
    Id? id,
    String? titulo,
    String? user,
    String? passW,
  }) => KeyValues(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    user: user ?? this.user,
    passW: passW ?? this.passW
  );
}