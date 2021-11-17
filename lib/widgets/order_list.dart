import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/order_detail.dart';
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
        height: (35 * orderItems.length).toDouble(),
        child: GroupedListView<OrderDetail, int>(
          elements: orderItems,
          groupBy: (order) => order.idProduct,
          groupSeparatorBuilder: (int groupValue) => Text(
            '${convertToTitleCase(Provider.of<Products>(context, listen: false).getProductById(groupValue)!.name.toString().trim())}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          indexedItemBuilder: (ctx, order, idx) => Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    order.quantity.toString(),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  currency.format(order.price),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  currency.format(order.quantity * order.price),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      );
    else
      return Container();
  }
}
