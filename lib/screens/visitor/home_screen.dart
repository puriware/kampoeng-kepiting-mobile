import 'package:flutter/material.dart';
import '../../providers/auth.dart';
import '../../providers/price_lists.dart';
import '../../widgets/user_profile.dart';
import '../../screens/visitor/product_detail_screen.dart';
import '../../constants.dart';
import '../../providers/products.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final Function changePage;
  const HomeScreen(this.changePage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    final userActive = Provider.of<Auth>(context, listen: false).activeUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: large),
        child: Column(
          children: [
            UserProfile(),
            SizedBox(
              height: medium,
            ),
            Expanded(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              products[i].id,
                              openShop: changePage,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Hero(
                                tag: products[i].id,
                                child: Image.network(
                                  '$imageUrl${products[i].image.toString()}.jpg',
                                  fit: BoxFit.fill,
                                ),
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
                                      Provider.of<PriceLists>(context,
                                              listen: false)
                                          .getMinimumProductPriceById(
                                        products[i].id,
                                        userActive!.jenisUser.toLowerCase(),
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
          ],
        ),
      ),
    );
  }
}
