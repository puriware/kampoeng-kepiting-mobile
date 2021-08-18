import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/order_detail.dart';
import '../services/order_detail_api.dart';

class Cart with ChangeNotifier {
  late OrderDetailApi _orderDetailApi;
  List<OrderDetail> _cart = [];
  String? token;

  Cart(this._cart, {this.token}) {
    if (this.token != null) {
      _orderDetailApi = OrderDetailApi(this.token!);
    }
  }

  Future<void> fetchAndSetOrderDetails({userId}) async {
    try {
      _cart = userId != null
          ? await _orderDetailApi.getOrderCart(userId)
          : await _orderDetailApi.getOrderDetails();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<OrderDetail> get items {
    return [..._cart];
  }

  int get itemCount {
    return _cart.length;
  }

  double get totalAmount {
    double total = 0.0;
    _cart.forEach((cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  void clear() {
    _cart = [];
    notifyListeners();
  }

  OrderDetail? getOrderDetailById(
    int id,
  ) {
    final result = _cart.firstWhereOrNull(
      (orderDetail) => orderDetail.id == id,
    );
    return result;
  }

  Future<void> createItem(OrderDetail data) async {
    try {
      final newID = await _orderDetailApi.createOrderDetail(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _cart.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(OrderDetail data) async {
    final indexProduct = _cart
        .indexWhere((orderDetail) => orderDetail.idProduct == data.idProduct);
    if (indexProduct >= 0) {
      final selectedProduct = _cart[indexProduct];
      selectedProduct.quantity += data.quantity;
      try {
        final isSuccess =
            await _orderDetailApi.updateOrderDetail(selectedProduct);
        if (isSuccess) {
          _cart[indexProduct] = selectedProduct;
          notifyListeners();
        }
      } catch (error) {
        throw error;
      }
    } else {
      createItem(data);
    }
  }

  Future<String> deleteItem(int id) async {
    var result = 'Successfully deleted data';
    final orderDetailIndex =
        _cart.indexWhere((orderDetail) => orderDetail.id == id);

    if (orderDetailIndex >= 0) {
      try {
        final isSuccess = await _orderDetailApi.deleteOrderDetail(id);
        if (isSuccess) {
          _cart.removeAt(orderDetailIndex);
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

  void removeSingleItem(int productId) async {
    final indexProduct =
        _cart.indexWhere((element) => element.idProduct == productId);
    if (indexProduct < 0) return;
    final selectedProduct = _cart[indexProduct];
    if (selectedProduct.quantity > 1) {
      selectedProduct.quantity -= 1;
      try {
        final isSuccess =
            await _orderDetailApi.updateOrderDetail(selectedProduct);
        if (isSuccess) {
          _cart[indexProduct] = selectedProduct;
          notifyListeners();
        }
      } catch (error) {
        throw error;
      }
    } else {
      await deleteItem(selectedProduct.id);
    }

    notifyListeners();
  }
}
