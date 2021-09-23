import '../constants.dart';
import '../models/user.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class UserApi {
  final String baseUrl = apiUrl;
  final Client client = Client();
  final String token;
  UserApi(this.token);

  Future<List<User>> getUsers() async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/users'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<User>.from(
          data['values'].map(
            (item) => User.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<User?> findUser(String email) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/users/$email'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<User>.from(
          data['values'].map(
            (item) => User.fromJson(item),
          ),
        )[0];
      } else {
        return null;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<User>> findUserBy(String key, String value) async {
    try {
      final response = await client.get(
        Uri.https(baseUrl, '/users/$key/$value'),
        headers: {'token': token},
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        return List<User>.from(
          data['values'].map(
            (item) => User.fromJson(item),
          ),
        );
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> createUser(User data) async {
    try {
      final response = await client.post(
        Uri.https(baseUrl, '/users'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: User.userToJson(data),
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

  Future<bool> updateUser(User data) async {
    try {
      final response = await client.put(
        Uri.https(baseUrl, '/users'),
        headers: {
          'content-type': 'application/json',
          'token': token,
        },
        body: User.userToJson(data),
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

  Future<bool> deleteUser(int id) async {
    try {
      final response = await client.delete(
        Uri.https(baseUrl, '/users/$id'),
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
