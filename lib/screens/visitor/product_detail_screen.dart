import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/models/price_list.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/price_lists.dart';
import 'package:kampoeng_kepiting_mobile/widgets/toggle_buttons_creation.dart';
import '../../constants.dart';
import '../../models/order_detail.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../widgets/badge.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<PriceList> _priceList = [];
  List<bool>? _selectedPrice;
  var _price = 0.0;
  var _priceCategory = 'Individu';
  var _isLoading = false;
  var _quantity = 1;

  Widget _buildToggleWidget() {
    if (_selectedPrice == null) {
      _selectedPrice = List.filled(_priceList.length, false);
      _selectedPrice![0] = true;
    }
    return ToggleButtonsCreation(
      _priceList.map((item) => item.orderType).toList(),
      _selectedPrice!,
      _setProductPrice,
    );
  }

  void _setProductPrice(int index) {
    if (_priceList.isNotEmpty && _selectedPrice != null) {
      setState(() {
        _price = _priceList[index].price;
        _priceCategory = _priceList[index].orderType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).activeUser!.id;
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final productID = args[0] as int;
    final goToShop = args[1] as Function;
    final product =
        Provider.of<Products>(context, listen: false).getProductById(productID);
    _priceList = Provider.of<PriceLists>(context, listen: false)
        .getProductPriceByProductId(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          convertToTitleCase(product!.name),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
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
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: large),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  product.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              large,
                            ),
                          ),
                          child: Hero(
                            tag: productID,
                            child: Image.network(
                              '$imageUrl${product.image.toString()}.jpg',
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
                      _price > 0 ? _price : _priceList[0].price,
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
                    convertToTitleCase(product.name),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: medium,
                  ),
                  SafeArea(
                    child: _buildToggleWidget(),
                  ),
                  SizedBox(
                    height: large,
                  ),
                  Text(
                    product.feature,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: medium,
                  ),
                  Text(
                    product.description,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                iconSize: large,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  var value = _quantity;
                                  if (value > 1) value--;
                                  setState(() {
                                    _quantity = value;
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
                                  var value = _quantity;
                                  value++;
                                  setState(() {
                                    _quantity = value;
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
                                userId: userId,
                                idProduct: product.id,
                                orderType: _priceCategory,
                                quantity: _quantity,
                                price:
                                    _price > 0 ? _price : _priceList[0].price,
                              );
                              await Provider.of<OrderDetails>(context,
                                      listen: false)
                                  .addItem(newCart);
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added item to the cart!'),
                                  duration: Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      Provider.of<OrderDetails>(context,
                                              listen: false)
                                          .removeSingleItem(
                                        product.id,
                                        _priceCategory,
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
                                : Text('Add to Chart'),
                            style: TextButton.styleFrom(primary: primaryColor),
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
      ),
    );
  }
}
