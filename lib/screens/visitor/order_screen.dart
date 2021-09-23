import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/providers/orders.dart';
import 'package:kampoeng_kepiting_mobile/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    print(orders.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (ctx, idx) {
            return OrderItem(orders[idx]);
          },
        ),
      ),
    );
  }
}
