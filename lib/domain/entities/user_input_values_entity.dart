class UserInputValues {
  String name;
  String password;

  UserInputValues({
    required this.name,
    required this.password
  });

  UserInputValues copyWith({
    String? name,
    String? password
  }) => UserInputValues(
    name: name ?? this.name,
    password: password ?? this.password
  );
}