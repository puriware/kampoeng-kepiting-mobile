import '../constants.dart';
import '../models/province.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class ProvinceApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  ProvinceApi(this.token);

  Future<List<Province>> getProvinces() async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/provinces'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Province>.from(
          data['values'].map(
            (item) => Province.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Province>> findProvince(String code) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/provinces/$code'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Province>.from(
          data['values'].map(
            (item) => Province.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Province>> findProvinceBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/provinces/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Province>.from(
          data['values'].map(
            (item) => Province.fromJson(item),
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
