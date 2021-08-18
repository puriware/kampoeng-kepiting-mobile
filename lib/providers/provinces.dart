import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/province.dart';
import '../services/province_api.dart';

class Provinces with ChangeNotifier {
  late ProvinceApi _provinceApi;
  List<Province> _provinces = [];
  String? token;

  Provinces(this._provinces, {this.token}) {
    if (this.token != null) {
      _provinceApi = ProvinceApi(this.token!);
    }
  }

  Future<void> fetchAndSetProvinces() async {
    try {
      _provinces = await _provinceApi.getProvinces();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Province> get provinces {
    return [..._provinces];
  }

  Province? getProvinceById(
    String id,
  ) {
    final result = _provinces.firstWhereOrNull(
      (province) => province.id == id,
    );
    return result;
  }
}
