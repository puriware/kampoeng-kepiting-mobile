import '../constants.dart';
import '../models/visit.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class VisitApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  VisitApi(this.token);

  Future<List<Visit>> getVisits() async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/visits'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Visit>.from(
          data['values'].map(
            (item) => Visit.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Visit>> findVisit(String id) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/visits/$id'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Visit>.from(
          data['values'].map(
            (item) => Visit.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Visit>> findVisitBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/visits/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Visit>.from(
          data['values'].map(
            (item) => Visit.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createVisit(Visit data) async {
    try {
      final response = await client.post(
        Uri.http(baseUrl, '/visits'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Visit.visitToJson(data),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String id = data['values']['insertId'].toString();
        return id;
      } else {
        return null;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> updateVisit(Visit data) async {
    try {
      final response = await client.put(
        Uri.http(baseUrl, '/visits'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Visit.visitToJson(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> deleteVisit(int id) async {
    try {
      final response = await client.delete(
        Uri.http(baseUrl, '/visits/$id'),
        headers: {'token': token},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }
}
