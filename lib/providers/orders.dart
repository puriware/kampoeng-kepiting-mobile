import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/order.dart';
import '../services/order_api.dart';

class Orders with ChangeNotifier {
  late OrderApi _orderApi;
  List<Order> _orders = [];
  String? token;

  Orders(this._orders, {this.token}) {
    if (this.token != null) {
      _orderApi = OrderApi(this.token!);
    }
  }

  Future<void> fetchAndSetOrders({userId}) async {
    try {
      _orders = userId != null
          ? await _orderApi.findOrderBy(
              'id_customer',
              userId.toString(),
            )
          : await _orderApi.getOrders();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Order> get orders {
    return [..._orders];
  }

  Order? getOrderById(
    int id,
  ) {
    final result = _orders.firstWhereOrNull(
      (order) => order.id == id,
    );
    return result;
  }

  Future<String> addOrder(Order data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _orderApi.createOrder(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _orders.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updateOrder(Order data) async {
    var result = 'Submit updated data is success';
    final orderIndex = _orders.indexWhere((order) => order.id == data.id);

    if (orderIndex >= 0) {
      try {
        final isSuccess = await _orderApi.updateOrder(data);
        if (isSuccess) {
          _orders[orderIndex] = data;
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

  Future<String> deleteOrder(int id) async {
    var result = 'Successfully deleted data';
    final orderIndex = _orders.indexWhere((order) => order.id == id);

    if (orderIndex >= 0) {
      try {
        final isSuccess = await _orderApi.deleteOrder(id);
        if (isSuccess) {
          _orders.removeAt(orderIndex);
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
