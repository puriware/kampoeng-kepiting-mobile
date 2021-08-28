import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/models/order.dart';
import 'package:kampoeng_kepiting_mobile/providers/auth.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/orders.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import '../../constants.dart';
import '../../widgets/cart_item.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderDetails>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shoping List'),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(large),
              // ),
              margin: EdgeInsets.all(large),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    cart.itemCount.toString(),
                  ),
                ),
                title: Text('Total Price'),
                subtitle: Text(
                  currency.format(cart.totalAmount),
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                trailing: OrderButton(cart: cart),
              ),
            ),
            SizedBox(
              height: medium,
            ),
            Text(
              cart.itemCount > 0 ? 'Shopping Cart' : 'Shopping Cart is Empty',
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => CartItem(
                  cart.items[index].id,
                ),
                itemCount: cart.items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final OrderDetails cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).activeUser!.id;
    final cart = widget.cart;
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          cart.itemCount > 0 ? primaryColor : primaryBackgrounColor,
        ),
      ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<OrderDetails>(context, listen: false)
                    .fetchAndSetOrderDetails(userId: userId);
                final newOrder = Order(
                  idCustomer: userId,
                  total: cart.totalAmount,
                  disc: 0.0,
                  grandTotal: cart.totalAmount,
                  status: 'Belum Dibayar',
                );
                final newOrderID =
                    await Provider.of<Orders>(context, listen: false)
                        .addOrder(newOrder);
                if (newOrderID != null) {
                  cart.items.forEach((cartItem) async {
                    cartItem.orderId = newOrderID;
                    await Provider.of<OrderDetails>(context, listen: false)
                        .updateOrderDetail(cartItem);
                  });
                  //cart.clear();
                  MessageDialog.showPopUpMessage(
                    context,
                    'Order Success',
                    'Ticket order has been successful. Please proceed to the payment process.',
                  );
                } else {
                  MessageDialog.showPopUpMessage(
                    context,
                    'Error',
                    'Failed to process irder',
                  );
                }
              } catch (err) {
                MessageDialog.showPopUpMessage(
                  context,
                  'Error',
                  err.toString(),
                );
              }

              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? CircularProgressIndicator(
              color: Theme.of(context).accentColor,
            )
          : Text('ORDER NOW'),
    );
  }
}
