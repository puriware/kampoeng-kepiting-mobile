import 'dart:convert';

class Redeem {
  int id;
  String voucherCode;
  int quantity;
  int officer;
  DateTime? created;

  Redeem({
    this.id = 0,
    required this.voucherCode,
    required this.quantity,
    required this.officer,
    this.created,
  });

  factory Redeem.fromJson(Map<String, dynamic> map) {
    return Redeem(
      id: map["id"],
      voucherCode: map["id_product"],
      quantity: map["quantity"],
      officer: map["officer"],
      created: map["created"] != null
          ? DateTime.parse(map["created"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "id_product": voucherCode,
      "quantity": quantity,
      "officer": officer,
      "created": created,
    };
  }

  @override
  String toString() {
    return 'Redeem{id: $id, id_product: $voucherCode, quantity: $quantity, officer: $officer, created: $created}';
  }

  static List<Redeem> redeemFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Redeem>.from(
      data["values"].map(
        (item) => Redeem.fromJson(item),
      ),
    );
  }

  static String redeemToJson(Redeem data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
