import 'dart:convert';

class Product {
  int id;
  String code;
  String name;
  String description;
  String feature;
  double price;
  String? image;
  int createBy;
  String visibility;
  DateTime? created;
  DateTime? updated;

  Product({
    this.id = 0,
    required this.code,
    required this.name,
    required this.description,
    required this.feature,
    required this.price,
    this.image,
    required this.createBy,
    required this.visibility,
    this.created,
    this.updated,
  });

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map["id"],
      code: map["code"],
      name: map["name"],
      description: map["description"],
      feature: map["feature"],
      price: map["price"],
      image: map["image"],
      createBy: map["createBy"],
      visibility: map["visibility"],
      created: map["created"],
      updated: map["updated"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "description": description,
      "feature": feature,
      "price": price,
      "image": image,
      "createBy": createBy,
      "visibility": visibility,
      "created": created,
      "updated": updated,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, code: $code, name: $name, description: $description, feature: $feature, price: $price, image: $image, createBy: $createBy, visibility: $visibility, created: $created, updated: $updated, updated: $updated}';
  }

  static List<Product> productFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Product>.from(
      data["values"].map(
        (item) => Product.fromJson(item),
      ),
    );
  }

  static String productToJson(Product data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
