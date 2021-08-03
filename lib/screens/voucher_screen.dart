import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';

class VoucherScreen extends StatefulWidget {
  VoucherScreen({Key? key}) : super(key: key);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(large),
          topRight: Radius.circular(large),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: small,
        vertical: 0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.qr_code),
                ),
                title: Text(
                  'Activity 1',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('5 Voucher left'),
                trailing: Icon(Icons.qr_code),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
