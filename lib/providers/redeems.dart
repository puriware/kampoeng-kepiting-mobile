import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/redeem.dart';
import '../services/redeem_api.dart';

class Redeems with ChangeNotifier {
  late RedeemApi _redeemApi;
  List<Redeem> _redeems = [];
  String? token;

  Redeems(this._redeems, {this.token}) {
    if (this.token != null) {
      _redeemApi = RedeemApi(this.token!);
    }
  }

  Future<void> fetchAndSetRedeems({userId}) async {
    try {
      _redeems = userId != null
          ? await _redeemApi.findRedeemBy(
              'id_customer',
              userId.toString(),
            )
          : await _redeemApi.getRedeems();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Redeem> get redeems {
    return [..._redeems];
  }

  Redeem? getRedeemById(
    int id,
  ) {
    final result = _redeems.firstWhere(
      (redeem) => redeem.id == id,
    );
    return result;
  }

  Future<String> addRedeem(Redeem data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _redeemApi.createRedeem(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _redeems.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updateRedeem(Redeem data) async {
    var result = 'Submit updated data is success';
    final redeemIndex = _redeems.indexWhere((redeem) => redeem.id == data.id);

    if (redeemIndex >= 0) {
      try {
        final isSuccess = await _redeemApi.updateRedeem(data);
        if (isSuccess) {
          _redeems[redeemIndex] = data;
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

  Future<String> deleteRedeem(int id) async {
    var result = 'Successfully deleted data';
    final redeemIndex = _redeems.indexWhere((redeem) => redeem.id == id);

    if (redeemIndex >= 0) {
      try {
        final isSuccess = await _redeemApi.deleteRedeem(id);
        if (isSuccess) {
          _redeems.removeAt(redeemIndex);
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
