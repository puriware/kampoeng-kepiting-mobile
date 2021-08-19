import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/order_detail.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../widgets/badge.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).activeUser!.id;
    final productID = ModalRoute.of(context)!.settings.arguments as int;
    final product =
        Provider.of<Products>(context, listen: false).getProductById(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product!.name,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, _child) => Badge(
              child: _child!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () async {
                //Navigator.of(context).pushNamed(CartScreen.routeName);
                final newCart = OrderDetail(
                  userId: userId,
                  idProduct: product.id,
                  orderType: 'Test',
                  quantity: 1,
                  price: product.price,
                );
                print(newCart);
                await Provider.of<Cart>(context, listen: false)
                    .addItem(newCart);
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(large),
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
                          child: Image.network(
                            '$imageUrl${product.image.toString()}.jpg',
                            fit: BoxFit.fill,
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
                    currency.format(product.price),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: medium,
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
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.payment_rounded),
                            label: Text('Buy Now'),
                            style: TextButton.styleFrom(primary: primaryColor),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.shopping_basket_rounded),
                            label: Text('Add to Chart'),
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
