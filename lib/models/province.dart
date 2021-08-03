import 'dart:convert';

class Province {
  String id;
  String name;

  Province({
    required this.id,
    required this.name,
  });

  factory Province.fromJson(Map<String, dynamic> map) {
    return Province(
      id: map["id"],
      name: map["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  String toString() {
    return 'Province{id: $id, name: $name}';
  }

  static List<Province> provinceFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Province>.from(
      data["values"].map(
        (item) => Province.fromJson(item),
      ),
    );
  }

  static String provinceToJson(Province data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
