import '../constants.dart';
import '../models/regency.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class RegencyApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  RegencyApi(this.token);

  Future<List<Regency>> getRegencys() async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/regencies'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Regency>.from(
          data['values'].map(
            (item) => Regency.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Regency>> findRegency(String code) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/regencies/$code'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Regency>.from(
          data['values'].map(
            (item) => Regency.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Regency>> findRegencyBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/regencies/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Regency>.from(
          data['values'].map(
            (item) => Regency.fromJson(item),
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
