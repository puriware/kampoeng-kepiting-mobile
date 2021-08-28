import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import '../../providers/products.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final int cartId;
  const CartItem(
    this.cartId, {
    Key? key,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var _quantity = 0;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderDetails>(
      context,
    ).getCartById(widget.cartId);
    if (cart != null) _quantity = cart.quantity;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).getProductById(cart!.idProduct);

    return Dismissible(
      key: ValueKey(cart.id),
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
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Sure'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<OrderDetails>(context, listen: false).deleteItem(cart.id);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: Row(
          children: [
            product!.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        small,
                      ),
                      bottomLeft: Radius.circular(
                        small,
                      ),
                    ),
                    child: Image.network(
                      '$imageUrl${product.image.toString()}.jpg',
                      fit: BoxFit.fill,
                      width: 76,
                      height: 76,
                    ),
                  )
                : Container(
                    width: 76,
                    height: 76,
                    color: Colors.grey,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      convertToTitleCase(product.name),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${cart.orderType}'),
                            Text(
                              currency.format((cart.price * cart.quantity)),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: small),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(large),
                            ),
                            color: Theme.of(context).accentColor,
                          ),
                          width: 120,
                          height: 32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                iconSize: large,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await Provider.of<OrderDetails>(context,
                                            listen: false)
                                        .removeSingleItem(
                                      cart.idProduct,
                                      cart.orderType,
                                    );
                                    var value = _quantity;
                                    if (value > 0) value--;
                                    _quantity = value;
                                  } catch (err) {
                                    MessageDialog.showPopUpMessage(
                                        context, 'Error', err.toString());
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.minus,
                                ),
                              ),
                              _isLoading
                                  ? SizedBox(
                                      height: large,
                                      width: large,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(_quantity.toString()),
                              IconButton(
                                iconSize: large,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await Provider.of<OrderDetails>(context,
                                            listen: false)
                                        .addSingleItem(
                                      cart.idProduct,
                                      cart.orderType,
                                    );
                                    _quantity++;
                                  } catch (err) {
                                    MessageDialog.showPopUpMessage(
                                        context, 'Error', err.toString());
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.add,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
