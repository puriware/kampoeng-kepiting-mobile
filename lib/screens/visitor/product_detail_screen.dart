import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/models/price_list.dart';
import 'package:kampoeng_kepiting_mobile/models/product.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/price_lists.dart';
import '../../constants.dart';
import '../../models/order_detail.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../widgets/badge.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productID;
  final Function? openShop;

  ProductDetailScreen(this.productID, {this.openShop, Key? key})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<PriceList> _priceList = [];
  var _isInit = true;
  var _price = 0.0;
  var _userType = 'Individu';
  var _userID = -1;
  var _productID = -1;
  var _isLoading = false;
  var _quantity = 1;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _productID = widget.productID;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _product = Provider.of<Products>(context, listen: false)
          .getProductById(_productID);
      _priceList = Provider.of<PriceLists>(context, listen: false)
          .getProductPriceByProductId(_productID);
      if (_product != null) _quantity = _product!.minOrder;
      _isInit = false;
    }
  }

  double _getProductPrice(int order) {
    var price = 0.0;
    if (_priceList.isNotEmpty) {
      final result = _priceList.firstWhereOrNull((pl) =>
          pl.idProduct == _productID &&
          pl.orderType.toLowerCase() == _userType.toLowerCase() &&
          pl.minPax <= order &&
          pl.maxPax >= order);
      price = result != null ? result.price : 0.0;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = Provider.of<Auth>(context).activeUser;
    if (activeUser != null) {
      _userType = activeUser.jenisUser.toString();
      _userID = activeUser.id;
    }

    // final args = ModalRoute.of(context)!.settings.arguments as List;
    // _productID = args[0] as int;
    // final goToShop = args[1] as Function;
    final goToShop = widget.openShop;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _product != null
              ? convertToTitleCase(_product!.name)
              : 'Product Detail',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (goToShop != null)
            Consumer<OrderDetails>(
              builder: (_, cart, _child) => Badge(
                child: _child!,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  //Navigator.of(context).pushNamed(CartScreen.routeName);
                  Navigator.of(context).pop();
                  goToShop(1);
                },
              ),
            ),
        ],
      ),
      body: _product != null
          ? Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: large),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _product!.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    large,
                                  ),
                                ),
                                child: Hero(
                                  tag: _productID,
                                  child: Image.network(
                                    '$imageUrl${_product!.image.toString()}.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: 100,
                                color: Colors.grey,
                              ),
                        SizedBox(
                          height: large,
                        ),
                        Text(
                          currency.format(
                            _getProductPrice(_quantity),
                          ),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          height: medium,
                        ),
                        Text(
                          convertToTitleCase(_product!.name.trim()),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: large,
                        ),
                        if (_product!.remark != '')
                          Text(
                            convertToTitleCase(_product!.remark),
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        if (_product!.remark != '')
                          SizedBox(
                            height: medium,
                          ),
                        Text(
                          _product!.description,
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 96,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(large),
                      child: Card(
                        elevation: medium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(large),
                        ),
                        child: Container(
                          height: 64.0,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(right: small),
                                width: 120,
                                height: 32,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      iconSize: large,
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        if (_quantity > _product!.minOrder)
                                          setState(() {
                                            _quantity -= 1;
                                          });
                                      },
                                      icon: Icon(
                                        CupertinoIcons.minus,
                                      ),
                                    ),
                                    Text(_quantity.toString()),
                                    IconButton(
                                      iconSize: large,
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        setState(() {
                                          _quantity += 1;
                                        });
                                      },
                                      icon: Icon(
                                        CupertinoIcons.add,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              VerticalDivider(),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final newCart = OrderDetail(
                                      userId: _userID,
                                      idProduct: _product!.id,
                                      orderType: _userType,
                                      quantity: _quantity,
                                      price: _price > 0
                                          ? _price
                                          : _priceList[0].price,
                                    );
                                    await Provider.of<OrderDetails>(context,
                                            listen: false)
                                        .addItem(newCart, context);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Added item to the cart!'),
                                        duration: Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          onPressed: () {
                                            Provider.of<OrderDetails>(context,
                                                    listen: false)
                                                .removeSingleItem(
                                              _userID,
                                              _product!.id,
                                              _userType,
                                              context,
                                              number: _quantity,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.shopping_basket_rounded),
                                  label: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text('Add to Cart'),
                                  style: TextButton.styleFrom(
                                      primary: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                )
              ],
            )
          : Center(
              child: Text('Ooppsss... Product not found...'),
            ),
    );
  }
}
