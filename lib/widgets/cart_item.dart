import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/order_detail.dart';
import 'package:kampoeng_kepiting_mobile/models/price_list.dart';
import 'package:kampoeng_kepiting_mobile/models/product.dart';
import 'package:kampoeng_kepiting_mobile/providers/auth.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/price_lists.dart';
import 'package:kampoeng_kepiting_mobile/screens/visitor/product_detail_screen.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import '../../providers/products.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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
  var _isInit = true;
  var _quantity = 0;
  var _userID = -1;
  var _isLoading = false;
  Product? product;
  OrderDetail? _cart;
  List<PriceList> _priceList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _cart = Provider.of<OrderDetails>(
        context,
      ).getCartById(widget.cartId);
      if (_cart != null) {
        _quantity = _cart!.quantity;
        product = Provider.of<Products>(
          context,
          listen: false,
        ).getProductById(_cart!.idProduct);
      }
      final activeUser = Provider.of<Auth>(context).activeUser;
      if (activeUser != null) {
        _userID = activeUser.id;
      }
      _priceList = Provider.of<PriceLists>(context, listen: false)
          .getProductPriceByProductId(_cart!.idProduct);
      _isInit = false;
    }
  }

  double _getProductPrice(int order) {
    var price = 0.0;
    if (_priceList.isNotEmpty && _cart != null) {
      final result = _priceList.firstWhereOrNull((pl) =>
          pl.idProduct == product!.id &&
          pl.orderType.toLowerCase() == _cart!.orderType.toLowerCase() &&
          pl.minPax <= order &&
          pl.maxPax >= order);
      price = result != null ? result.price : 0.0;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return product != null && _cart != null
        ? Card(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product!.id,
                    ),
                  ),
                );
              },
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
                            '$imageUrl${product!.image.toString()}.jpg',
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
                            convertToTitleCase(
                              product!.name.toString().trim().length > 25
                                  ? product!.name
                                      .toString()
                                      .trim()
                                      .substring(0, 25)
                                  : product!.name.toString().trim(),
                            ),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${convertToTitleCase(_cart!.orderType)}'),
                                  Text(
                                    currency.format(
                                        (_cart!.price * _cart!.quantity)),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                width: 120,
                                height: 32,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      iconSize: large,
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          if (_quantity > product!.minOrder) {
                                            await Provider.of<OrderDetails>(
                                                    context,
                                                    listen: false)
                                                .removeSingleItem(
                                              _userID,
                                              _cart!.idProduct,
                                              _cart!.orderType,
                                              context,
                                            );
                                            _quantity -= 1;
                                          }
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
                                        : Text(
                                            _quantity.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    IconButton(
                                      iconSize: large,
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          await Provider.of<OrderDetails>(
                                                  context,
                                                  listen: false)
                                              .addSingleItem(
                                            _userID,
                                            _cart!.idProduct,
                                            _cart!.orderType,
                                            context,
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
          )
        : Center();
  }
}
