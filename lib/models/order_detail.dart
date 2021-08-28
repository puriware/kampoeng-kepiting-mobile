import 'dart:convert';

class OrderDetail {
  int id;
  int userId;
  int? orderId;
  int idProduct;
  String orderType;
  int quantity;
  double price;
  DateTime? visitDate;
  String? note;
  String? voucherCode;
  int remaining;
  DateTime? created;
  DateTime? updated;

  OrderDetail({
    this.id = 0,
    required this.userId,
    this.orderId,
    required this.idProduct,
    required this.orderType,
    required this.quantity,
    required this.price,
    this.visitDate,
    this.note,
    this.voucherCode,
    this.remaining = 0,
    this.created,
    this.updated,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> map) {
    return OrderDetail(
      id: map["id"],
      userId: map["userId"],
      orderId: map["orderId"],
      idProduct: map["id_product"],
      orderType: map["orderType"],
      quantity: map["quantity"],
      price: double.parse(map["price"].toString()),
      visitDate: map["visitDate"],
      note: map["note"],
      voucherCode: map["voucherCode"],
      remaining: map["remaining"],
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
      "userId": userId,
      "orderId": orderId,
      "id_product": idProduct,
      "orderType": orderType,
      "quantity": quantity,
      "price": price,
      "visitDate": visitDate != null ? visitDate!.toIso8601String() : null,
      "note": note,
      "voucherCode": voucherCode,
      "remaining": remaining,
      "created": created != null ? created!.toIso8601String() : null,
      "updated": updated != null ? updated!.toIso8601String() : null,
    };
  }

  @override
  String toString() {
    return 'OrderDetail{id: $id, userId: $userId, orderId: $orderId, id_product: $idProduct, orderType: $orderType, quantity: $quantity, price: $price, visitDate: $visitDate, note: $note, voucherCode: $voucherCode, remaining: $remaining, created: $created, updated: $updated}';
  }

  static List<OrderDetail> orderDetailFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<OrderDetail>.from(
      data["values"].map(
        (item) => OrderDetail.fromJson(item),
      ),
    );
  }

  static String orderDetailToJson(OrderDetail data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
