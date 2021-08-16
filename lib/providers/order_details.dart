import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> fetchAndSetOrderDetails({userId}) async {
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

  List<OrderDetail>? get voucherIssued {
    return _orderDetails.where((order) => order.voucherCode != null).toList();
  }

  OrderDetail? getOrderDetailById(
    int id,
  ) {
    final result = _orderDetails.firstWhere(
      (orderDetail) => orderDetail.id == id,
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
}
