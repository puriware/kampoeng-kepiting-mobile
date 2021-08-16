import 'dart:convert';

class Order {
  int id;
  String bookingCode;
  int idCustomer;
  double total;
  double disc;
  double grandTotal;
  String status;
  int? verifiedBy;
  DateTime? created;
  DateTime? updated;

  Order({
    this.id = 0,
    required this.bookingCode,
    required this.idCustomer,
    required this.total,
    required this.disc,
    required this.grandTotal,
    required this.status,
    this.verifiedBy,
    this.created,
    this.updated,
  });

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map["id"],
      bookingCode: map["bookingCode"],
      idCustomer: map["id_customer"],
      total: double.parse(map["total"].toString()),
      disc: double.parse(map["disc"].toString()),
      grandTotal: double.parse(map["grandTotal"].toString()),
      status: map["status"],
      verifiedBy: map["verifiedBy"],
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
      "bookingCode": bookingCode,
      "id_customer": idCustomer,
      "total": total,
      "disc": disc,
      "grandTotal": grandTotal,
      "status": status,
      "verifiedBy": verifiedBy,
      "created": created,
      "updated": updated,
    };
  }

  @override
  String toString() {
    return 'Order{id: $id, bookingCode: $bookingCode, id_customer: $idCustomer, total: $total, disc: $disc, grandTotal: $grandTotal, status: $status, verifiedBy: $verifiedBy, created: $created, updated: $updated}';
  }

  static List<Order> orderFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Order>.from(
      data["values"].map(
        (item) => Order.fromJson(item),
      ),
    );
  }

  static String orderToJson(Order data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
