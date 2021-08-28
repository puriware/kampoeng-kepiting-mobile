import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/providers/auth.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context, listen: false).activeUser!;
    final totalVoucher =
        Provider.of<OrderDetails>(context).totalAvailableVoucers;
    return Card(
      color: primaryColor,
      elevation: medium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(large),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: userData.picture.isEmpty
              ? Icon(
                  Icons.person,
                )
              : ClipOval(
                  child: Image.network(
                    userData.picture,
                    fit: BoxFit.fill,
                  ),
                ),
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          '${userData.firstname.toString()} ${userData.lastname.toString()}',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
        subtitle: Text(
          userData.email,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: Text(
          userData.level == 'userData' ? '$totalVoucher Voucher' : '',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
