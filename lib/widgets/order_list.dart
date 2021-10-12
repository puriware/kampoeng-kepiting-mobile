import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/products.dart';
import 'package:provider/provider.dart';

class OrderList extends StatelessWidget {
  final int orderId;
  const OrderList(this.orderId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderItems = Provider.of<OrderDetails>(context, listen: false)
        .getOrderDetailByOrderId(orderId);
    if (orderItems != null)
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ...orderItems
                    .map(
                      (e) => Text(
                        e.quantity.toString(),
                      ),
                    )
                    .toList()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...orderItems.map(
                  (e) {
                    final product =
                        Provider.of<Products>(context, listen: false)
                            .getProductById(e.idProduct);
                    return Text(
                      product != null
                          ? convertToTitleCase(product.name.trim())
                          : 'Unknown',
                    );
                  },
                ).toList()
              ],
            ),
            Column(
              children: [
                ...orderItems
                    .map(
                      (e) => Text(
                        currency.format(e.price),
                      ),
                    )
                    .toList()
              ],
            ),
          ],
        ),
      );
    else
      return Container();
  }
}
