import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/price_list.dart';
import '../services/price_list_api.dart';

class PriceLists with ChangeNotifier {
  late PriceListApi _priceListApi;
  List<PriceList> _priceLists = [];
  String? token;

  PriceLists(this._priceLists, {this.token}) {
    if (this.token != null) {
      _priceListApi = PriceListApi(this.token!);
    }
  }

  Future<void> fetchAndSetPriceLists() async {
    try {
      _priceLists = await _priceListApi.getPriceLists();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<PriceList> get priceLists {
    return [..._priceLists];
  }

  PriceList? getPriceListById(
    int id,
  ) {
    final result = _priceLists.firstWhere(
      (prodList) => prodList.id == id,
    );
    return result;
  }

  Future<String> addPriceList(PriceList data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _priceListApi.createPriceList(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _priceLists.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updatePriceList(PriceList data) async {
    var result = 'Submit updated data is success';
    final prodListIndex =
        _priceLists.indexWhere((prodList) => prodList.id == data.id);

    if (prodListIndex >= 0) {
      try {
        final isSuccess = await _priceListApi.updatePriceList(data);
        if (isSuccess) {
          _priceLists[prodListIndex] = data;
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

  Future<String> deletePriceList(int id) async {
    var result = 'Successfully deleted data';
    final prodListIndex =
        _priceLists.indexWhere((prodList) => prodList.id == id);

    if (prodListIndex >= 0) {
      try {
        final isSuccess = await _priceListApi.deletePriceList(id);
        if (isSuccess) {
          _priceLists.removeAt(prodListIndex);
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
