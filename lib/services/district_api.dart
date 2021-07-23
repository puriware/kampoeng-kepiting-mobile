import '../constants.dart';
import '../models/district.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class DistrictApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  DistrictApi(this.token);

  Future<List<District>> getDistricts() async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/districts'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<District>.from(
          data['values'].map(
            (item) => District.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<District>> findDistrict(String code) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/districts/$code'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<District>.from(
          data['values'].map(
            (item) => District.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<District>> findDistrictBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/districts/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<District>.from(
          data['values'].map(
            (item) => District.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }
}
