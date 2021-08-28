import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
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

  Future<void> fetchAndSetVisits({int? userId, int? officerId}) async {
    try {
      if (userId != null) {
        _visits = await _visitApi.findVisitBy(
          'visitor',
          userId.toString(),
        );
      } else if (officerId != null) {
        _visits = await _visitApi.findVisitBy(
          'officer',
          officerId.toString(),
        );
      } else {
        _visits = await _visitApi.getVisits();
      }

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
    final result = _visits.firstWhereOrNull(
      (visit) => visit.id == id,
    );
    return result;
  }

  Visit? getVisitByCode(
    String visitCode,
  ) {
    final result = _visits.firstWhereOrNull(
      (visit) => visit.visitCode == visitCode,
    );
    return result;
  }

  List<Visit> getTodaysVisit({int? visitorId, int? officerId}) {
    final now = DateTime.now();
    var result = _visits
        .where(
          (vst) =>
              vst.created != null &&
              vst.created!.year == now.year &&
              vst.created!.month == now.month &&
              vst.created!.day == now.day,
        )
        .toList();
    if (result.length > 0) {
      if (visitorId != null) {
        result = result.where((vst) => vst.visitor == visitorId).toList();
      }

      if (officerId != null) {
        result = result.where((vst) => vst.officer == officerId).toList();
      }
    }
    return result;
  }

  int get todaysTotalVisit {
    final now = DateTime.now();
    var result = _visits
        .where(
          (vst) =>
              vst.visitTime != null &&
              vst.visitTime!.year == now.year &&
              vst.visitTime!.month == now.month &&
              vst.visitTime!.day == now.day,
        )
        .toList();
    return result.length;
  }

  List<Visit> get thisWeekVisits {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = today.weekday;
    final start = today.add(Duration(days: -(weekday - 1)));
    return [
      ..._visits
          .where(
            (vst) =>
                vst.visitTime != null &&
                vst.visitTime!.year >= start.year &&
                vst.visitTime!.month >= start.month &&
                vst.visitTime!.day >= start.day,
          )
          .toList()
    ];
  }

  List<Visit> get prevWeekVisits {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = today.weekday;
    final start = today.add(Duration(days: -(6 + weekday)));
    final end = today.add(Duration(days: -weekday));
    return [
      ..._visits
          .where(
            (vst) =>
                vst.visitTime != null &&
                vst.visitTime!.year >= start.year &&
                vst.visitTime!.month >= start.month &&
                vst.visitTime!.day >= start.day &&
                vst.visitTime!.year <= end.year &&
                vst.visitTime!.month <= end.month &&
                vst.visitTime!.day <= end.day,
          )
          .toList()
    ];
  }

  int get thisWeekTotalVisit {
    return thisWeekVisits.length;
  }

  int get prevWeekTotalVisit {
    return prevWeekVisits.length;
  }

  List<Visit> getVisitByOfficer(int officerId) {
    return _visits.where((vst) => vst.officer == officerId).toList();
  }

  Future<Visit?> getVisitByIdFromServer(
    int id,
  ) async {
    final result = await _visitApi.findVisit(id);

    return result.isNotEmpty ? result[0] : null;
  }

  Future<String> addVisit(Visit data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _visitApi.createVisit(data);
      if (newID != null) {
        final id = int.parse(newID);
        final result = await getVisitByIdFromServer(id);
        if (result != null) _visits.insert(0, result);
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
