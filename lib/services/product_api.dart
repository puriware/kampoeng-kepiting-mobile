import '../constants.dart';
import '../models/product.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class ProductApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  ProductApi(this.token);

  Future<List<Product>> getProducts() async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/products'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Product>.from(
          data['values'].map(
            (item) => Product.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Product>> findProduct(String code) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/products/$code'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Product>.from(
          data['values'].map(
            (item) => Product.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Product>> findProductBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/products/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Product>.from(
          data['values'].map(
            (item) => Product.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createProduct(Product data) async {
    try {
      final response = await client.post(
        Uri.http(baseUrl, '/products'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Product.productToJson(data),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String id = data['values']['insertId'].toString();
        return id;
      } else {
        return null;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> updateProduct(Product data) async {
    try {
      final response = await client.put(
        Uri.http(baseUrl, '/products'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Product.productToJson(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await client.delete(
        Uri.http(baseUrl, '/products/$id'),
        headers: {'token': token},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }
}
