import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/providers/auth.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          Provider.of<Auth>(context, listen: false).logOut();
        },
        child: Text('Logout'),
      ),
    );
  }
}
