import 'dart:convert';

class District {
  String id;
  String regencyId;
  String name;

  District({
    required this.id,
    required this.regencyId,
    required this.name,
  });

  factory District.fromJson(Map<String, dynamic> map) {
    return District(
      id: map["id"],
      regencyId: map["regency_id"],
      name: map["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "regency_id": regencyId,
      "name": name,
    };
  }

  @override
  String toString() {
    return 'District{id: $id, regency_id: $regencyId, name: $name}';
  }

  static List<District> districtFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<District>.from(
      data["values"].map(
        (item) => District.fromJson(item),
      ),
    );
  }

  static String districtToJson(District data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
