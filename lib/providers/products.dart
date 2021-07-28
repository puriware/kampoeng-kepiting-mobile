import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_api.dart';

class Products with ChangeNotifier {
  late ProductApi _productApi;
  List<Product> _products = [];
  String? token;

  Products(this._products, {this.token}) {
    if (this.token != null) {
      _productApi = ProductApi(this.token!);
    }
  }

  Future<void> fetchAndSetProducts() async {
    try {
      _products = await _productApi.getProducts();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get products {
    return [..._products];
  }

  Product? getProductById(
    int id,
  ) {
    final result = _products.firstWhere(
      (prod) => prod.id == id,
    );
    return result;
  }

  Future<String> addProduct(Product data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _productApi.createProduct(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _products.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updateProduct(Product data) async {
    var result = 'Submit updated data is success';
    final prodIndex = _products.indexWhere((prod) => prod.id == data.id);

    if (prodIndex >= 0) {
      try {
        final isSuccess = await _productApi.updateProduct(data);
        if (isSuccess) {
          _products[prodIndex] = data;
          notifyListeners();
        }
      } catch (error) {
        throw error;
      }
    } else {
      result = 'Failed to update data. Data not found.';
    }
    return result;
  }

  Future<String> deleteProduct(int id) async {
    var result = 'Successfully deleted data';
    final prodIndex = _products.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      try {
        final isSuccess = await _productApi.deleteProduct(id);
        if (isSuccess) {
          _products.removeAt(prodIndex);
          notifyListeners();
        }
      } catch (error) {
        throw error;
      }
    } else {
      result = 'Failed to delete data. Data not found.';
    }
    return result;
  }
}
