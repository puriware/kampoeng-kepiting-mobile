import 'dart:convert';

class Visit {
  int id;
  int visitor;
  String? province;
  String? regency;
  String? district;
  String region;
  String visitCode;
  int? officer;
  DateTime? visitTime;
  DateTime? created;
  DateTime? updated;

  Visit({
    this.id = 0,
    required this.visitor,
    this.province,
    this.regency,
    this.district,
    required this.region,
    required this.visitCode,
    this.officer,
    this.visitTime,
    this.created,
    this.updated,
  });

  factory Visit.fromJson(Map<String, dynamic> map) {
    return Visit(
      id: map["id"],
      visitor: map["visitor"],
      province: map["province"],
      regency: map["regency"],
      district: map["district"],
      region: map["region"],
      visitCode: map["visitCode"],
      officer: map["officer"],
      visitTime: map["visitTime"] != null
          ? DateTime.parse(map["visitTime"].toString())
          : null,
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
      "visitor": visitor,
      "province": province,
      "regency": regency,
      "district": district,
      "region": region,
      "visitCode": visitCode,
      "officer": officer,
      "visitTime": visitTime != null ? visitTime!.toIso8601String() : null,
      "created": created != null
          ? created!.toIso8601String()
          : DateTime.now().toIso8601String(),
      "updated": updated != null
          ? updated!.toIso8601String()
          : DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Visit{id: $id, visitor: $visitor, province: $province, regency: $regency, district: $district, region: $region, visitCode: $visitCode, officer: $officer, visitTime: $visitTime, created: $created, updated: $updated}';
  }

  static List<Visit> visitFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Visit>.from(
      data["values"].map(
        (item) => Visit.fromJson(item),
      ),
    );
  }

  static String visitToJson(Visit data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
