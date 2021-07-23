import '../constants.dart';
import '../models/price_list.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class PriceListApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  PriceListApi(this.token);

  Future<List<PriceList>> getPriceLists() async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/price-lists'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<PriceList>.from(
          data['values'].map(
            (item) => PriceList.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<PriceList>> findPriceList(String id) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/price-lists/$id'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<PriceList>.from(
          data['values'].map(
            (item) => PriceList.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<PriceList>> findPriceListBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.http(baseUrl, '/price-lists/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<PriceList>.from(
          data['values'].map(
            (item) => PriceList.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createPriceList(PriceList data) async {
    try {
      final response = await client.post(
        Uri.http(baseUrl, '/price-lists'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: PriceList.priceListToJson(data),
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

  Future<bool> updatePriceList(PriceList data) async {
    try {
      final response = await client.put(
        Uri.http(baseUrl, '/price-lists'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: PriceList.priceListToJson(data),
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

  Future<bool> deletePriceList(int id) async {
    try {
      final response = await client.delete(
        Uri.http(baseUrl, '/price-lists/$id'),
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
