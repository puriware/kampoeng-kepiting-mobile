import 'dart:convert';

class Product {
  int id;
  String code;
  String name;
  String description;
  String englishDescription;
  String feature;
  double price;
  String? image;
  String duration;
  String remark;
  int minOrder;
  int createBy;
  String visibility;
  DateTime? created;
  DateTime? updated;

  Product({
    this.id = 0,
    required this.code,
    required this.name,
    required this.description,
    this.englishDescription = '',
    required this.feature,
    required this.price,
    this.image,
    this.duration = '',
    this.remark = '',
    this.minOrder = 1,
    required this.createBy,
    required this.visibility,
    this.created,
    this.updated,
  });

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map["id"],
      code: map["code"].toString(),
      name: map["name"].toString(),
      description: map["description"].toString(),
      englishDescription: map["description_english"].toString(),
      feature: map["feature"].toString(),
      price: double.parse(map["price"].toString()),
      image: map["image"],
      duration: map["duration"],
      remark: map["remark"],
      minOrder: map["minorder"],
      createBy: map["createBy"],
      visibility: map["visibility"],
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
      "code": code,
      "name": name,
      "description": description,
      "description_english": englishDescription,
      "feature": feature,
      "price": price,
      "image": image,
      "duration": duration,
      "remark": remark,
      "minorder": minOrder,
      "createBy": createBy,
      "visibility": visibility,
      "created": created,
      "updated": updated,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, code: $code, name: $name, description: $description, description_english: $englishDescription, feature: $feature, price: $price, image: $image, duration: $duration, remark: $remark, minorder: $minOrder, createBy: $createBy, visibility: $visibility, created: $created, updated: $updated}';
  }

  static List<Product> productFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Product>.from(
      data["values"].map(
        (item) => Product.fromJson(item),
      ),
    );
  }

  static String productToJson(Product data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
