import '../constants.dart';
import '../models/order.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class OrderApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  OrderApi(this.token);

  Future<List<Order>> getOrders() async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/orders'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Order>.from(
          data['values'].map(
            (item) => Order.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Order>> findOrder(String id) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/orders/$id'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Order>.from(
          data['values'].map(
            (item) => Order.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Order>> findOrderBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/orders/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Order>.from(
          data['values'].map(
            (item) => Order.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createOrder(Order data) async {
    try {
      final response = await client.post(
        Uri.https(baseUrl, '/orders'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Order.orderToJson(data),
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

  Future<bool> updateOrder(Order data) async {
    try {
      final response = await client.put(
        Uri.https(baseUrl, '/orders'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Order.orderToJson(data),
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

  Future<bool> deleteOrder(int id) async {
    try {
      final response = await client.delete(
        Uri.https(baseUrl, '/orders/$id'),
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
