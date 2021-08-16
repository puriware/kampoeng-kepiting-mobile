import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/user_api.dart';

class Users with ChangeNotifier {
  late UserApi _userApi;
  List<User> _users = [];
  String? token;

  Users(this._users, {this.token}) {
    if (this.token != null) {
      _userApi = UserApi(this.token!);
    }
  }

  Future<void> fetchAndSetUsers() async {
    try {
      _users = await _userApi.getUsers();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<User> get users {
    return [..._users];
  }

  User? getUserById(
    int id,
  ) {
    User? result = _users.firstWhere((user) => user.id == id);
    return result;
  }

  Future<String> addUser(User data) async {
    var result = "Submit new data is success";
    try {
      final newID = await _userApi.createUser(data);
      if (newID != null) {
        data.id = int.parse(newID);
        _users.insert(0, data);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    return result;
  }

  Future<String> updateUser(User data) async {
    var result = 'Submit updated data is success';
    final userIndex = _users.indexWhere((user) => user.id == data.id);

    if (userIndex >= 0) {
      try {
        final isSuccess = await _userApi.updateUser(data);
        if (isSuccess) {
          _users[userIndex] = data;
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

  Future<String> deleteUser(int id) async {
    var result = 'Successfully deleted data';
    final userIndex = _users.indexWhere((user) => user.id == id);

    if (userIndex >= 0) {
      try {
        final isSuccess = await _userApi.deleteUser(id);
        if (isSuccess) {
          _users.removeAt(userIndex);
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
