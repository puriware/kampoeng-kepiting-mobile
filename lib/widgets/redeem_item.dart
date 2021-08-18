import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/redeem.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/products.dart';
import 'package:kampoeng_kepiting_mobile/providers/redeems.dart';
import 'package:kampoeng_kepiting_mobile/providers/users.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class RedeemItem extends StatefulWidget {
  final Redeem redeemData;
  final int number;
  const RedeemItem(this.redeemData, this.number, {Key? key}) : super(key: key);

  @override
  _RedeemItemState createState() => _RedeemItemState();
}

class _RedeemItemState extends State<RedeemItem> {
  Future<void> _deleteRedeem(int redeemId) async {
    await Provider.of<Redeems>(context, listen: false).deleteRedeem(redeemId);
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderDetails>(context, listen: false)
        .getOrderDetailByVoucherCode(widget.redeemData.voucherCode);
    final userData = Provider.of<Users>(context, listen: false)
        .getUserById(orderData!.userId);
    final productData = Provider.of<Products>(context, listen: false)
        .getProductById(orderData.idProduct);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(large),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryBackgrounColor,
          child: Text((widget.number).toString()), // Icon(Icons.qr_code),
        ),
        title: Text(
          '${userData!.firstname.toString()} ${userData.lastname.toString()}',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          convertToTitleCase(productData!.name),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.redeemData.quantity.toString()} person',
              style: TextStyle(color: primaryColor),
            ),
            Text(
              DateFormat('HH:mm').format(widget.redeemData.created!),
            ),
          ],
        ),
        onLongPress: () async {
          await MessageDialog.showMessageDialog(
            context,
            'Delete Redeem Data',
            'Are you sure to delete this redeem data?',
            'Sure',
            _deleteRedeem,
            args: widget.redeemData.id,
          );
        },
      ),
    );
  }
}
