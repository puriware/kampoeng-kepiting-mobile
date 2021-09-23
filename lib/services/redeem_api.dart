import '../constants.dart';
import '../models/redeem.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class RedeemApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  RedeemApi(this.token);

  Future<List<Redeem>> getRedeems() async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/redeems'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Redeem>.from(
          data['values'].map(
            (item) => Redeem.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Redeem>> findRedeem(String code) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/redeems/$code'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Redeem>.from(
          data['values'].map(
            (item) => Redeem.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Redeem>> findRedeemBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/redeems/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<Redeem>.from(
          data['values'].map(
            (item) => Redeem.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createRedeem(Redeem data) async {
    try {
      final response = await client.post(
        Uri.https(baseUrl, '/redeems'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Redeem.redeemToJson(data),
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

  Future<bool> updateRedeem(Redeem data) async {
    try {
      final response = await client.put(
        Uri.https(baseUrl, '/redeems'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: Redeem.redeemToJson(data),
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

  Future<bool> deleteRedeem(int id) async {
    try {
      final response = await client.delete(
        Uri.https(baseUrl, '/redeems/$id'),
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
