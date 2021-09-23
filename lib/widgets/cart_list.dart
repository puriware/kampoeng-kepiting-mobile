import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/models/order_detail.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartList extends StatefulWidget {
  final List<OrderDetail> cart;
  CartList(this.cart, {Key? key}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  List<OrderDetail> cartData = [];

  @override
  void initState() {
    super.initState();
    cartData = widget.cart;
  }

  @override
  Widget build(BuildContext context) {
    return cartData.length > 0
        ? ListView.builder(
            itemCount: cartData.length,
            itemBuilder: (ctx, idx) => Dismissible(
              key: ValueKey(cartData[idx].id),
              background: Container(
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryTextTheme.headline6!.color,
                  size: 32,
                ),
                color: Theme.of(context).errorColor,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content:
                        Text('Do you want to remove the item from the cart?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Sure'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) async {
                final result =
                    await Provider.of<OrderDetails>(context, listen: false)
                        .deleteOrderDetail(cartData[idx].id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.toString(),
                    ),
                  ),
                );
                setState(() {
                  cartData.removeAt(idx);
                });
              },
              child: CartItem(cartData[idx].id),
            ),
          )
        : Center();
  }
}
