import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: large,
        right: large,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(large)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  'I Wayan Jepriana',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('Another Information'),
                trailing: Text('5 Voucher'),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(large)),
              child: Container(
                height: 150,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(large)),
              child: Container(
                height: 150,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(large)),
              child: Container(
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
