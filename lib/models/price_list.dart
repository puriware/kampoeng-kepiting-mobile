import 'dart:convert';

class PriceList {
  int id;
  int idProduct;
  String orderType;
  double price;
  DateTime? created;
  DateTime? updated;

  PriceList({
    this.id = 0,
    required this.idProduct,
    required this.orderType,
    required this.price,
    this.created,
    this.updated,
  });

  factory PriceList.fromJson(Map<String, dynamic> map) {
    return PriceList(
      id: map["id"],
      idProduct: map["id_product"],
      orderType: map["orderType"],
      price: map["price"],
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
      "id_product": idProduct,
      "orderType": orderType,
      "price": price,
      "created": created,
      "updated": updated,
    };
  }

  @override
  String toString() {
    return 'PriceList{id: $id, id_product: $idProduct, orderType: $orderType, price: $price, created: $created, updated: $updated}';
  }

  static List<PriceList> priceListFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<PriceList>.from(
      data["values"].map(
        (item) => PriceList.fromJson(item),
      ),
    );
  }

  static String priceListToJson(PriceList data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
