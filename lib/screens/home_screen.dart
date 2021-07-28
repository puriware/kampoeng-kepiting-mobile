import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/screens/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = PRODUCTS;
    return Stack(
      children: [
        Container(color: primaryColor, child: null),
        Container(
          margin: const EdgeInsets.only(
            top: 50,
          ),
          padding: EdgeInsets.only(
            top: 40,
            bottom: 0,
            left: large,
            right: large,
          ),
          color: primaryBackgrounColor,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: large, horizontal: 0),
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
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                          products[i].name.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Rp ${products[i].price.toString()}',
                          style: TextStyle(color: primaryColor),
                        ),
                        SizedBox(
                          height: small,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(mediumLarge),
          child: Card(
            elevation: medium,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryBackgrounColor,
                child: Icon(Icons.person),
              ),
              title: Text(
                'I Wayan Jepriana',
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text('Another Information'),
              trailing: Text('5 Voucher'),
            ),
          ),
        ),
      ],
    );
  }
}
