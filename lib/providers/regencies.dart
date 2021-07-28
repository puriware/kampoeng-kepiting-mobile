import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/regency.dart';
import '../services/regency_api.dart';

class Regencies with ChangeNotifier {
  late RegencyApi _regencyApi;
  List<Regency> _regencies = [];
  String? token;

  Regencies(this._regencies, {this.token}) {
    if (this.token != null) {
      _regencyApi = RegencyApi(this.token!);
    }
  }

  Future<void> fetchAndSetRegencies() async {
    try {
      _regencies = await _regencyApi.getRegencies();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Regency> get regencies {
    return [..._regencies];
  }

  Regency? getRegencyById(
    String id,
  ) {
    final result = _regencies.firstWhere(
      (regency) => regency.id == id,
    );
    return result;
  }

  List<Regency>? getRegencyByProvinceId(
    String id,
  ) {
    final result = _regencies
        .where(
          (regency) => regency.provinceId == id,
        )
        .toList();
    return result;
  }
}
