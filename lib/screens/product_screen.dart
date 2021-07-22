import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/screens/product_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({Key? key}) : super(key: key);

  final products = PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large,
        vertical: 0,
      ),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: large,
          mainAxisSpacing: large,
        ),
        itemBuilder: (ctx, i) => ClipRRect(
          borderRadius: BorderRadius.circular(large),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: products[i].id,
                );
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        products[i].image.toString(),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Text(
                      products[i].name.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Rp ${products[i].price.toString()}',
                    ),
                  ],
                ),
              ),
            ),
            // footer: GridTileBar(
            //   backgroundColor: Colors.black54,
            //   // leading: Consumer<Product>(
            //   //   builder: (ctx, product, child) => IconButton(
            //   //     icon: Icon(
            //   //       product.isFavorite ? Icons.favorite : Icons.favorite_border,
            //   //     ),
            //   //     color: Theme.of(context).accentColor,
            //   //     onPressed: () {
            //   //       product.toggleFavoriteStatus(
            //   //         authData.token,
            //   //         authData.userId,
            //   //       );
            //   //     },
            //   //   ),
            //   // ),
            //   title: Text(
            //     products[i].name.toString(),
            //     textAlign: TextAlign.center,
            //   ),
            //   trailing: Text('Rp ${products[i].price.toString()}'),
            //),
          ),
        ),
      ),
    );
  }
}
