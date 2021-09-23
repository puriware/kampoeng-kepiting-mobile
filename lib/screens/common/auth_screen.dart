import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/message_dialog.dart';
import '../../../constants.dart';
import '../../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    inactiveColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: orientation == Orientation.portrait
                        ? deviceSize.width * 0.75
                        : deviceSize.width * 0.3,
                    //child: Image.asset('assets/images/knwt.png'),
                  ),
                ),
              ],
            ),
            // orientation == Orientation.portrait
            //     ? SingleChildScrollView(
            //         child: Container(
            //           margin: EdgeInsets.only(top: 100),
            //           height: deviceSize.height,
            //           width: deviceSize.width,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: <Widget>[
            //               Container(
            //                 width: deviceSize.width * 0.75,
            //                 // child: Image.asset(
            //                 //   'assets/logos/tracetales_full_logo.png',
            //                 // ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     : Container(
            //         height: deviceSize.height,
            //         width: deviceSize.width,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: <Widget>[
            //             Flexible(
            //               child: Container(
            //                 width: deviceSize.width * 0.40,
            //                 child: Image.asset(
            //                     'assets/logos/tracetales_full_logo.png'),
            //               ),
            //             ),
            //             Flexible(
            //               child: Container(
            //                   width: deviceSize.width * 0.30,
            //                   child: AuthCard()),
            //             ),
            //           ],
            //         ),
            //       ),
            orientation == Orientation.portrait
                ? Center(
                    child: Container(
                      width: deviceSize.width * 0.85,
                      child: AuthCard(),
                    ),
                  )
                : Center(
                    child: Container(
                      width: deviceSize.width * 0.35,
                      child: AuthCard(),
                    ),
                  ),
          ],
        );
      }),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _passwordVisible = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // Log user in
    try {
      var result = await Provider.of<Auth>(context, listen: false).signIn(
        _authData['username']!,
        _authData['password']!,
      );
      var loginResult = jsonDecode(result) as Map<String, dynamic>;
      var status = loginResult['status'];
      if (status != 'success') {
        var message = loginResult['message'];
        MessageDialog.showPopUpMessage(
          context,
          'Login $status',
          message,
        );
      }
    } catch (error) {
      MessageDialog.showPopUpMessage(
        context,
        'Login Error',
        error.toString(),
      );
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 265,
        constraints: BoxConstraints(minHeight: 200),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  appName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: large,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                    ),
                    hintText: 'Enter your e-mail address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Username is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['username'] = value!;
                  },
                ),
                SizedBox(
                  height: medium,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                    hintText: 'Enter password',
                  ),
                  obscureText: !_passwordVisible,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator(
                    color: primaryColor,
                  )
                else
                  TextButton(
                    child: Text('LOGIN'),
                    onPressed: _submit,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      backgroundColor:
                          primaryColor, // Theme.of(context).primaryColor,
                      primary: whiteBackgrounColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
