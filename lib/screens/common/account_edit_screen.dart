import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/user.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class AccountEditScreen extends StatefulWidget {
  AccountEditScreen({Key? key}) : super(key: key);

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _formKey = GlobalKey<FormState>();
  User? _activeUser;
  var _isInit = true;
  var _isLoading = false;
  var _passwordVisible = false;
  var _prevPassord = '';
  TextEditingController _firstNameCtrl = TextEditingController();
  TextEditingController _lastNameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();
  TextEditingController _repeatPasswordCtrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _activeUser = Provider.of<Auth>(context, listen: false).activeUser;
      if (_activeUser != null) {
        _firstNameCtrl.text = _activeUser!.firstname;
        _lastNameCtrl.text = _activeUser!.lastname;
        _emailCtrl.text = _activeUser!.email;
        _phoneCtrl.text = _activeUser!.phone;
        _prevPassord = _activeUser!.password;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _encryptPassword(String plainText) {
    return md5.convert(utf8.encode(plainText)).toString();
  }

  _saveAccountData() async {
    if (_formKey.currentState!.validate()) {
      try {
        var tempPassword = _prevPassord;
        if (_passwordCtrl.text.isNotEmpty && _activeUser != null)
          tempPassword = _encryptPassword(_passwordCtrl.text);
        _activeUser!.firstname = _firstNameCtrl.text;
        _activeUser!.lastname = _lastNameCtrl.text;
        _activeUser!.email = _emailCtrl.text;
        _activeUser!.phone = _phoneCtrl.text;
        _activeUser!.password = tempPassword;
        await Provider.of<Users>(context, listen: false)
            .updateUser(_activeUser!);
        Navigator.of(context).pop();
      } catch (err) {
        MessageDialog.showPopUpMessage(
          context,
          'Error',
          err.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('User Account'),
        actions: [
          IconButton(
            onPressed: _saveAccountData,
            icon: Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: _isLoading || _activeUser == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(large),
                ),
              ),
              padding: EdgeInsets.all(large),
              margin: EdgeInsets.only(
                left: large,
                right: large,
                bottom: large,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Account Details',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(
                        height: large,
                      ),
                      //Text('Your name'),
                      SizedBox(
                        height: medium,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First name',
                                border: OutlineInputBorder(),
                                //prefixIcon: Icon(Icons.house_rounded),
                              ),
                              controller: _firstNameCtrl,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your fist name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: large,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last name',
                                border: OutlineInputBorder(),
                                //prefixIcon: Icon(Icons.house_rounded),
                              ),
                              controller: _lastNameCtrl,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: large,
                      ),
                      //Text('Email'),
                      SizedBox(
                        height: medium,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter your valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: large,
                      ),
                      //Text('Phone'),
                      SizedBox(
                        height: medium,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.smartphone_rounded),
                        ),
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 5) {
                            return 'Please enter your valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: large,
                      ),
                      //Text('Password'),
                      SizedBox(
                        height: medium,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        controller: _passwordCtrl,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: large,
                      ),
                      //Text('Confirm Password'),
                      SizedBox(
                        height: medium,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        controller: _repeatPasswordCtrl,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (_passwordCtrl.text.isNotEmpty &&
                              _passwordCtrl.text != value) {
                            return 'Please re-enter your password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
