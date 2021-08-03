import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:kampoeng_kepiting_mobile/services/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';

import '../constants.dart';

class Auth with ChangeNotifier {
  User? _activeUser;
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;
  UserApi? _userApi;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(
          DateTime.now(),
        ) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  User? get activeUser {
    return _activeUser;
  }

  Future<String> signIn(String email, String password) async {
    var result = {
      'status': 'success',
      'message': 'Login Success',
    };
    try {
      final String baseUrl = apiUrl;
      final urlLogin = Uri.http(baseUrl, '/auth/login');
      final res = await http.post(
        urlLogin,
        body: {
          'email': email,
          'password': password,
        },
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final jwt = body['token'];
        _activeUser = User.fromJson(body['values']);
        _token = jwt;
        _userApi = UserApi(_token!);
        _activeUser = await _userApi!.findUser(email);
        var arrayToken = jwt.split('.');
        if (arrayToken.length == 3) {
          var payload = jsonDecode(
            ascii.decode(
              base64.decode(
                base64.normalize(
                  arrayToken[1],
                ),
              ),
            ),
          );
          _expiryDate =
              DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
          _autoLogout();
          notifyListeners();
          final userData = jsonEncode({
            'token': _token,
            'email': email,
            'expiryDate': _expiryDate!.toIso8601String(),
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userData', userData);
        }
      } else {
        //print('No account was found matching that email and password');
        result = {
          'status': 'failed',
          'message': 'No account was found matching that email and password'
        };
      }
    } catch (error) {
      throw error;
    }
    return jsonEncode(result);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    if (userData == null) {
      return false;
    }

    final extractedUserData = jsonDecode(userData.toString());
    final expiryDate = DateTime.tryParse(
      extractedUserData['expiryDate'].toString(),
    );

    if (expiryDate == null || expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'].toString();
    final email = extractedUserData['email'].toString();
    _expiryDate = expiryDate;
    _userApi = UserApi(_token!);
    _activeUser = await _userApi!.findUser(email);
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _expiryDate = null;
    _activeUser = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
