import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstname': '',
    'lastname': '',
    'phone': '',
  };
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _passwordVisible = false;

  AnimationController? _ctrlAnimation;
  Animation<Size>? _heightAnimation;

  @override
  void initState() {
    super.initState();
    _ctrlAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      reverseDuration: Duration(
        milliseconds: 500,
      ),
    );
    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 140),
      end: Size(double.infinity, 360),
    ).animate(
      CurvedAnimation(
        parent: _ctrlAnimation!,
        curve: Curves.easeInOut, //.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_ctrlAnimation != null) _ctrlAnimation!.dispose();
  }

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
      var result = '';
      if (_authMode == AuthMode.Login) {
        result = await Provider.of<Auth>(context, listen: false).signIn(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        result = await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['password']!,
          _authData['firstname']!,
          _authData['lastname']!,
          _authData['phone']!,
        );
      }

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
        '${_authMode == AuthMode.Login ? 'Login' : 'Sign Up'} Error',
        error.toString(),
      );
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _ctrlAnimation!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _ctrlAnimation!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  height: _authMode == AuthMode.Login ? 200 : 0,
                  width: 200,
                  child:
                      Image.asset('assets/images/kampoeng_kepiting_icon.png'),
                ),
                Text(
                  _authMode == AuthMode.Login ? 'Welcome Back!' : 'Register',
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (_authMode == AuthMode.Login) ...[
                  SizedBox(
                    height: medium,
                  ),
                  Text(
                    'Login to your Kampoeng Kepiting account',
                  ),
                ],
                SizedBox(height: 32),
                AnimatedBuilder(
                  animation: _heightAnimation!,
                  builder: (ctx, ch) => Container(
                    height: _heightAnimation!.value.height,
                    child: ch,
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              //labelText: 'E-Mail',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(90),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(90),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              fillColor: Colors.white38,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.alternate_email_rounded,
                              ),
                              hintText: 'E-mail Address',
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 3 ||
                                  !value.contains('@')) {
                                return 'Please enter your valid e-mail address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value!;
                            },
                          ),
                          SizedBox(
                            height: large,
                          ),
                          if (_authMode == AuthMode.Signup) ...[
                            TextFormField(
                              decoration: InputDecoration(
                                //labelText: 'E-Mail',
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(90),
                                  ),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(90),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                fillColor: Colors.white38,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person_add_rounded,
                                ),
                                hintText: 'First Name',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['firstname'] = value!;
                              },
                            ),
                            SizedBox(
                              height: large,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                //labelText: 'E-Mail',
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(90),
                                  ),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(90),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                fillColor: Colors.white38,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person_add_alt_1_rounded,
                                ),
                                hintText: 'Last Name',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['lastname'] = value!;
                              },
                            ),
                            SizedBox(
                              height: large,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                //labelText: 'E-Mail',
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(90),
                                  ),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(90),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                fillColor: Colors.white38,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.smartphone_rounded,
                                ),
                                hintText: 'Phone Number',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['phone'] = value!;
                              },
                            ),
                            SizedBox(
                              height: large,
                            ),
                          ],
                          TextFormField(
                            decoration: InputDecoration(
                              //labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(90),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(90),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              fillColor: Colors.white38,
                              filled: true,
                              prefixIcon: Icon(Icons.lock_rounded),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.only(right: large),
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
                              hintText: 'Password',
                            ),
                            obscureText: !_passwordVisible,
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 5) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value!;
                            },
                            onFieldSubmitted: (_) => _submit(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: large,
                ),
                // AnimatedContainer(
                //   duration: const Duration(milliseconds: 500),
                //   curve: Curves.fastOutSlowIn,
                //   width: double.infinity,
                //   height: _authMode == AuthMode.Login ? 20 : 0,
                //   child: InkWell(
                //     child: Text(
                //       'Forgot password?',
                //       textAlign: TextAlign.end,
                //       style: TextStyle(
                //         color: primaryDarkerColor,
                //       ),
                //     ),
                //     onTap: () {},
                //   ),
                // ),
                // SizedBox(
                //   height: medium,
                // ),
                if (_isLoading)
                  CircularProgressIndicator(
                    color: primaryColor,
                  )
                else
                  Container(
                    height: 48,
                    width: 128,
                    child: TextButton(
                      child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                      ),
                      onPressed: _submit,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        backgroundColor:
                            primaryColor, // Theme.of(context).primaryColor,
                        primary: whiteBackgrounColor,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _authMode == AuthMode.Login
                          ? 'Don\'t have an account? '
                          : 'Already have an account?',
                    ),
                    TextButton(
                      child: Text(
                        _authMode == AuthMode.Login ? 'Sign Up' : 'Login',
                      ),
                      onPressed: _switchAuthMode,
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: MaterialStateProperty.all<Color>(
                          primaryDarkerColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
