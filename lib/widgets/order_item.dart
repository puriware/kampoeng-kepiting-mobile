import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kampoeng_kepiting_mobile/screens/visitor/payment_screen.dart';
import '../../constants.dart';
import 'dart:math';

import '../../models/order.dart';
import '../../providers/order_details.dart';
import '../../widgets/order_detail_item.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final total = widget.order.grandTotal > 0
        ? widget.order.grandTotal
        : widget.order.total;
    final orderDetails = Provider.of<OrderDetails>(context, listen: false)
        .getOrderDetailByOrderId(widget.order.id);
    final orderStatus =
        widget.order.bankName != null ? widget.order.status : "Belum Bayar";
    return InkWell(
      onTap: widget.order.bankName == null || widget.order.bankName!.isEmpty
          ? () {
              Navigator.of(context).pushNamed(PaymentScreen.routeName,
                  arguments: widget.order.id);
            }
          : null,
      child: Card(
        margin: EdgeInsets.only(
          left: large,
          bottom: 10,
          right: large,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${currency.format(total)}',
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                widget.order.created != null
                    ? '${DateFormat('dd-MMM-yyyy').format(widget.order.created!)} - $orderStatus'
                    : widget.order.status,
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded && orderDetails != null && orderDetails.length > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                height: min(orderDetails.length * 80 + 18.0, 177),
                child: ListView.builder(
                  itemCount: orderDetails.length,
                  itemBuilder: (ctx, idx) =>
                      OrderDetailItem(orderDetails[idx].id),
                ),
              )
          ],
        ),
      ),
    );
  }
}
