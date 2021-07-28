import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/district.dart';
import '../services/district_api.dart';

class Districts with ChangeNotifier {
  late DistrictApi _districtApi;
  List<District> _districts = [];
  String? token;

  Districts(this._districts, {this.token}) {
    if (this.token != null) {
      _districtApi = DistrictApi(this.token!);
    }
  }

  Future<void> fetchAndSetDistricts() async {
    try {
      _districts = await _districtApi.getDistricts();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<District> get districts {
    return [..._districts];
  }

  District? getDistrictById(
    String id,
  ) {
    final result = _districts.firstWhere(
      (district) => district.id == id,
    );
    return result;
  }

  List<District>? getDistrictByRegencyId(
    String id,
  ) {
    final result = _districts
        .where(
          (district) => district.regencyId == id,
        )
        .toList();
    return result;
  }
}
