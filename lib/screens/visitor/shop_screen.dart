import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/screens/visitor/payment_screen.dart';
import 'package:nanoid/async.dart';
import '../../models/order.dart';
import '../../providers/auth.dart';
import '../../providers/order_details.dart';
import '../../providers/orders.dart';
import '../../widgets/cart_list.dart';
import '../../widgets/message_dialog.dart';
import '../../constants.dart';
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              margin: EdgeInsets.all(large),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
              cart.itemCount > 0
                  ? 'Shopping Cart List'
                  : 'Shopping Cart is Empty',
            ),
            Expanded(
              child: CartList(),
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
                final newOrder = Order(
                  bookingCode: await nanoid(10),
                  idCustomer: userId,
                  total: cart.totalAmount,
                  disc: 0.0,
                  grandTotal: cart.totalAmount,
                  status: 'Perlu Verifikasi',
                  created: DateTime.now(),
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
                  await MessageDialog.showPopUpMessage(
                    context,
                    'Order Success',
                    'Ticket order has been successful. Please proceed to the payment process.',
                  );
                  Navigator.of(context).pushNamed(
                    PaymentScreen.routeName,
                    arguments: newOrderID,
                  );
                } else {
                  MessageDialog.showPopUpMessage(
                    context,
                    'Error',
                    'Failed to process order',
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
              color: Theme.of(context).colorScheme.secondary,
            )
          : Text('ORDER NOW'),
    );
  }
}
