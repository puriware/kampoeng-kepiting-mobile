import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../providers/products.dart';
import '../../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kampoeng Kepiting'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 76,
              bottom: 0,
              left: large,
              right: large,
            ),
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
                              '$imageUrl${products[i].image.toString()}.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(small),
                            child: Column(
                              children: [
                                Text(
                                  products[i].name.toString().length > 15
                                      ? products[i]
                                          .name
                                          .toString()
                                          .substring(0, 15)
                                      : products[i].name.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  currency.format(
                                    double.parse(
                                      products[i].price.toString(),
                                    ),
                                  ),
                                  style: TextStyle(color: primaryColor),
                                ),
                              ],
                            ),
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
            margin: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: mediumLarge,
            ),
            child: Card(
              color: primaryColor,
              elevation: medium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(large),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryBackgrounColor,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  'I Wayan Jepriana',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  'Another Information',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  '5 Voucher',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
