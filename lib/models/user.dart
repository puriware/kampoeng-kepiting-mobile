import 'dart:convert';

class User {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  String password;
  String level;
  String jenisUser;
  String picture;
  DateTime? created;
  DateTime? updated;

  User({
    this.id = 0,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.password,
    required this.level,
    this.jenisUser = 'Individu',
    this.picture = '',
    this.created,
    this.updated,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      firstname: map["firstname"].toString(),
      lastname: map["lastname"].toString(),
      email: map["email"].toString(),
      phone: map["phone"].toString(),
      password: map["password"].toString(),
      level: map["level"].toString(),
      jenisUser: map["jenisuser"].toString(),
      picture: map["picture"] ?? '',
      created: map["created"] != null
          ? DateTime.parse(map["created"].toString())
          : null,
      updated: map["updated"] != null
          ? DateTime.parse(map["updated"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstname": firstname.toString(),
      "lastname": lastname.toString(),
      "email": email.toString(),
      "phone": phone.toString(),
      "password": password.toString(),
      "level": level.toString(),
      "jenisuser": jenisUser.toString(),
      "created": created != null ? created!.toIso8601String() : null,
      "updated": updated != null ? updated!.toIso8601String() : null,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, firstname: $firstname, lastname: $lastname, email: $email, phone: $phone, password: $password, level: $level, jenisuser: $jenisUser, created: $created, updated: $updated}';
  }

  static List<User> userFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<User>.from(
      data["values"].map(
        (item) => User.fromJson(item),
      ),
    );
  }

  static String userToJson(User data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
