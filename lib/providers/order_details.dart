import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../../providers/price_lists.dart';
import 'package:provider/provider.dart';
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

  Future<void> fetchOrderDetailById(
    int id,
  ) async {
    final index = _orderDetails.indexWhere(
      (orderDetail) => orderDetail.id == id,
    );
    if (index >= 0) {
      final updated = await _orderDetailApi.findOrderDetail(id.toString());
      if (updated.isNotEmpty) {
        _orderDetails[index] = updated[0];
        notifyListeners();
      }
    }
  }

  List<OrderDetail>? getOrderDetailByOrderId(
    int id,
  ) {
    return _orderDetails
        .where(
          (orderDetail) => orderDetail.orderId == id,
        )
        .toList();
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

  Future<void> addItem(
    OrderDetail data,
    BuildContext ctx,
  ) async {
    final indexProduct = items.indexWhere((orderDetail) =>
        orderDetail.orderId == null &&
        orderDetail.idProduct == data.idProduct &&
        orderDetail.orderType == data.orderType &&
        orderDetail.userId == data.userId);
    if (indexProduct >= 0) {
      final selectedProduct = items[indexProduct];
      selectedProduct.quantity += data.quantity;
      selectedProduct.price = Provider.of<PriceLists>(ctx, listen: false)
          .getProductPrice(
              data.idProduct, data.orderType, selectedProduct.quantity);
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

  Future<void> addSingleItem(
    int userId,
    int productId,
    String orderType,
    BuildContext ctx,
  ) async {
    final indexProduct = items.indexWhere((element) =>
        element.userId == userId &&
        element.idProduct == productId &&
        element.orderType == orderType);
    if (indexProduct < 0) return;
    final selectedProduct = items[indexProduct];
    selectedProduct.quantity += 1;
    selectedProduct.price = Provider.of<PriceLists>(ctx, listen: false)
        .getProductPrice(productId, orderType, selectedProduct.quantity);
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

  Future<void> removeSingleItem(
      int userId, int productId, String orderType, BuildContext ctx,
      {int? number}) async {
    final indexProduct = items.indexWhere((element) =>
        element.userId == userId &&
        element.idProduct == productId &&
        element.orderType == orderType);
    if (indexProduct < 0) return;
    final selectedProduct = _orderDetails[indexProduct];
    final value = number ?? 1;
    if (selectedProduct.quantity > value) {
      selectedProduct.quantity -= value;
      selectedProduct.price = Provider.of<PriceLists>(ctx, listen: false)
          .getProductPrice(productId, orderType, selectedProduct.quantity);
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
      await deleteOrderDetail(selectedProduct.id);
    }

    notifyListeners();
  }

  // REDEEM SECTION
  List<OrderDetails>? getOrderOfTheWeek() {}
}
