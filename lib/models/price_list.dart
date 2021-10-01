import 'dart:convert';

class PriceList {
  int id;
  int idProduct;
  String orderType;
  int minPax;
  int maxPax;
  double price;
  DateTime? created;
  DateTime? updated;

  PriceList({
    this.id = 0,
    required this.idProduct,
    required this.orderType,
    this.minPax = 0,
    this.maxPax = 100,
    required this.price,
    this.created,
    this.updated,
  });

  factory PriceList.fromJson(Map<String, dynamic> map) {
    return PriceList(
      id: map["id"],
      idProduct: map["id_product"],
      orderType: map["orderType"],
      minPax: map["minpax"],
      maxPax: map["maxpax"],
      price: double.parse(
        map["price"].toString(),
      ),
      created: map["created"] != null
          ? DateTime.parse(
              map["created"].toString(),
            )
          : null,
      updated: map["updated"] != null
          ? DateTime.parse(
              map["updated"].toString(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "id_product": idProduct,
      "orderType": orderType,
      "minpax": minPax,
      "maxpax": maxPax,
      "price": price,
      "created": created != null ? created!.toIso8601String() : null,
      "updated": updated != null ? updated!.toIso8601String() : null,
    };
  }

  @override
  String toString() {
    return 'PriceList{id: $id, id_product: $idProduct, orderType: $orderType, price: $price, created: $created, updated: $updated, minpax: $minPax, maxpax: $maxPax}';
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
