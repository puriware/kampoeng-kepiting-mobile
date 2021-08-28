import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/order_detail.dart';
import '../services/order_detail_api.dart';

class OrderDetails with ChangeNotifier {
  late OrderDetailApi _orderDetailApi;
  List<OrderDetail> _orderDetails = [];
  String? token;

  OrderDetails(this._orderDetails, {this.token}) {
    if (this.token != null) {
      _orderDetailApi = OrderDetailApi(this.token!);
    }
  }

  Future<void> fetchAndSetOrderDetails({
    int? userId,
  }) async {
    try {
      _orderDetails = userId != null
          ? await _orderDetailApi.findOrderDetailBy(
              'userId',
              userId.toString(),
            )
          : await _orderDetailApi.getOrderDetails();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<OrderDetail> get orderDetails {
    return [..._orderDetails];
  }

  List<OrderDetail>? get availableVoucher {
    return _orderDetails
        .where((order) => order.voucherCode != null && order.remaining > 0)
        .toList();
  }

  int get totalAvailableVoucers {
    return availableVoucher != null ? availableVoucher!.length : 0;
  }

  List<OrderDetail>? get voucherIssued {
    return _orderDetails.where((order) => order.voucherCode != null).toList();
  }

  OrderDetail? getOrderDetailById(
    int id,
  ) {
    final result = _orderDetails.firstWhereOrNull(
      (orderDetail) => orderDetail.id == id,
    );
    return result;
  }

  OrderDetail? getOrderDetailByVoucherCode(
    String voucherCode,
  ) {
    final result = _orderDetails.firstWhereOrNull(
      (orderDetail) => orderDetail.voucherCode == voucherCode,
    );
    return result;
  }

  Future<String> addOrderDetail(OrderDetail data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _orderDetailApi.createOrderDetail(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _orderDetails.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updateOrderDetail(OrderDetail data) async {
    var result = 'Submit updated data is success';
    final orderDetailIndex =
        _orderDetails.indexWhere((orderDetail) => orderDetail.id == data.id);

    if (orderDetailIndex >= 0) {
      try {
        final isSuccess = await _orderDetailApi.updateOrderDetail(data);
        if (isSuccess) {
          _orderDetails[orderDetailIndex] = data;
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

  Future<String> deleteOrderDetail(int id) async {
    var result = 'Successfully deleted data';
    final orderDetailIndex =
        _orderDetails.indexWhere((orderDetail) => orderDetail.id == id);

    if (orderDetailIndex >= 0) {
      try {
        final isSuccess = await _orderDetailApi.deleteOrderDetail(id);
        if (isSuccess) {
          _orderDetails.removeAt(orderDetailIndex);
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

  // CART SECTION
  List<OrderDetail> get items {
    return _orderDetails.where((order) => order.orderId == null).toList();
  }

  int get itemCount {
    return items.length;
  }

  double get totalAmount {
    double total = 0.0;
    items.forEach((cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  // void clear() {
  //   items = [];
  //   notifyListeners();
  // }

  OrderDetail? getCartById(
    int id,
  ) {
    final result = items.firstWhereOrNull(
      (orderDetail) => orderDetail.id == id,
    );
    return result;
  }

  Future<void> createItem(OrderDetail data) async {
    try {
      final newID = await _orderDetailApi.createOrderDetail(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _orderDetails.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(OrderDetail data) async {
    final indexProduct = items.indexWhere((orderDetail) =>
        orderDetail.idProduct == data.idProduct &&
        orderDetail.orderType == data.orderType);
    if (indexProduct >= 0) {
      final selectedProduct = items[indexProduct];
      selectedProduct.quantity += data.quantity;
      try {
        final isSuccess =
            await _orderDetailApi.updateOrderDetail(selectedProduct);
        if (isSuccess) {
          items[indexProduct] = selectedProduct;
          notifyListeners();
        }
      } catch (error) {
        throw error;
      }
    } else {
      await addOrderDetail(data);
    }
  }

  Future<String> deleteItem(int id) async {
    var result = 'Successfully deleted data';
    final orderDetailIndex =
        items.indexWhere((orderDetail) => orderDetail.id == id);

    if (orderDetailIndex >= 0) {
      try {
        final isSuccess = await _orderDetailApi.deleteOrderDetail(id);
        if (isSuccess) {
          items.removeAt(orderDetailIndex);
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

  Future<void> addSingleItem(int productId, String orderType) async {
    final indexProduct = items.indexWhere((element) =>
        element.idProduct == productId && element.orderType == orderType);
    if (indexProduct < 0) return;
    final selectedProduct = items[indexProduct];
    selectedProduct.quantity += 1;
    try {
      final isSuccess =
          await _orderDetailApi.updateOrderDetail(selectedProduct);
      if (isSuccess) {
        items[indexProduct] = selectedProduct;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> removeSingleItem(int productId, String orderType,
      {int? number}) async {
    final indexProduct = items.indexWhere((element) =>
        element.idProduct == productId && element.orderType == orderType);
    if (indexProduct < 0) return;
    final selectedProduct = items[indexProduct];
    final value = number ?? 1;
    if (selectedProduct.quantity > value) {
      selectedProduct.quantity -= value;
      try {
        final isSuccess =
            await _orderDetailApi.updateOrderDetail(selectedProduct);
        if (isSuccess) {
          items[indexProduct] = selectedProduct;
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

  // REDEEM SECTION
  List<OrderDetails>? getOrderOfTheWeek() {}
}
