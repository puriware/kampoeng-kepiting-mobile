import 'dart:convert';

class Regency {
  String id;
  String provinceId;
  String name;

  Regency({
    required this.id,
    required this.provinceId,
    required this.name,
  });

  factory Regency.fromJson(Map<String, dynamic> map) {
    return Regency(
      id: map["id"],
      provinceId: map["province_id"],
      name: map["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "province_id": provinceId,
      "name": name,
    };
  }

  @override
  String toString() {
    return 'Regency{id: $id, province_id: $provinceId, name: $name}';
  }

  static List<Regency> regencyFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Regency>.from(
      data["values"].map(
        (item) => Regency.fromJson(item),
      ),
    );
  }

  static String regencyToJson(Regency data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
