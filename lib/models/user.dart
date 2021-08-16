import 'dart:convert';

class User {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  String password;
  String level;
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
    this.picture = '',
    this.created,
    this.updated,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      firstname: map["firstname"],
      lastname: map["lastname"],
      email: map["email"],
      phone: map["phone"],
      password: map["password"],
      level: map["level"],
      picture: map["picture"],
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
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "phone": phone,
      "password": password,
      "level": level,
      "created": created,
      "updated": updated,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, firstname: $firstname, lastname: $lastname, email: $email, phone: $phone, password: $password, level: $level, created: $created, updated: $updated}';
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
