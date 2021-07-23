import '../constants.dart';
import '../models/order_detail.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class OrderDetailApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  OrderDetailApi(this.token);

  Future<List<OrderDetail>> getOrderDetails() async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/order-details'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<OrderDetail>.from(
          data['values'].map(
            (item) => OrderDetail.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<OrderDetail>> findOrderDetail(String id) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/order-details/$id'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<OrderDetail>.from(
          data['values'].map(
            (item) => OrderDetail.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<OrderDetail>> findOrderDetailBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/order-details/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<OrderDetail>.from(
          data['values'].map(
            (item) => OrderDetail.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createOrderDetail(OrderDetail data) async {
    try {
      final response = await client.post(
        Uri.http(baseUrl, '/order-details'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: OrderDetail.orderDetailToJson(data),
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

  Future<bool> updateOrderDetail(OrderDetail data) async {
    try {
      final response = await client.put(
        Uri.http(baseUrl, '/order-details'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: OrderDetail.orderDetailToJson(data),
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

  Future<bool> deleteOrderDetail(int id) async {
    try {
      final response = await client.delete(
        Uri.http(baseUrl, '/order-details/$id'),
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
