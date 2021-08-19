import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: deviceSize.width * 0.60,
          child: Image.asset('assets/images/knwt.png'),
        ),
      ),
    );
  }
}
