import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/visit.dart';
import '../services/visit_api.dart';

class Visits with ChangeNotifier {
  late VisitApi _visitApi;
  List<Visit> _visits = [];
  String? token;

  Visits(this._visits, {this.token}) {
    if (this.token != null) {
      _visitApi = VisitApi(this.token!);
    }
  }

  Future<void> fetchAndSetVisits() async {
    try {
      _visits = await _visitApi.getVisits();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Visit> get visits {
    return [..._visits];
  }

  Visit? getVisitById(
    int id,
  ) {
    final result = _visits.firstWhere(
      (visit) => visit.id == id,
    );
    return result;
  }

  Future<String> addVisit(Visit data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _visitApi.createVisit(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _visits.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updateVisit(Visit data) async {
    var result = 'Submit updated data is success';
    final visitIndex = _visits.indexWhere((visit) => visit.id == data.id);

    if (visitIndex >= 0) {
      try {
        final isSuccess = await _visitApi.updateVisit(data);
        if (isSuccess) {
          _visits[visitIndex] = data;
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

  Future<String> deleteVisit(int id) async {
    var result = 'Successfully deleted data';
    final visitIndex = _visits.indexWhere((visit) => visit.id == id);

    if (visitIndex >= 0) {
      try {
        final isSuccess = await _visitApi.deleteVisit(id);
        if (isSuccess) {
          _visits.removeAt(visitIndex);
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
