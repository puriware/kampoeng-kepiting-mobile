import 'dart:convert';

class OrderDetail {
  int userId;
  int orderId;
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
    this.userId = 0,
    required this.orderId,
    required this.idProduct,
    required this.orderType,
    required this.quantity,
    required this.price,
    this.visitDate,
    this.note,
    this.voucherCode,
    required this.remaining,
    this.created,
    this.updated,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> map) {
    return OrderDetail(
      userId: map["userId"],
      orderId: map["orderId"],
      idProduct: map["id_product"],
      orderType: map["orderType"],
      quantity: map["quantity"],
      price: map["price"],
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
      "userId": userId,
      "orderId": orderId,
      "id_product": idProduct,
      "orderType": orderType,
      "quantity": quantity,
      "price": price,
      "visitDate": visitDate,
      "note": note,
      "voucherCode": voucherCode,
      "remaining": remaining,
      "created": created,
      "updated": updated,
    };
  }

  @override
  String toString() {
    return 'OrderDetail{userId: $userId, orderId: $orderId, id_product: $idProduct, orderType: $orderType, quantity: $quantity, price: $price, visitDate: $visitDate, note: $note, voucherCode: $voucherCode, remaining: $remaining, created: $created, updated: $updated}';
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
