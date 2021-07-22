// import 'package:flutter/material.dart';
// import 'package:kampoeng_kepiting_mobile/screens/product_detail_screen.dart';
// import 'package:provider/provider.dart';

// class ProductItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(15),
//       child: GridTile(
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pushNamed(
//               ProductDetailScreen.routeName,
//               arguments: product.id,
//             );
//           },
//           child: Image.network(
//             product.imageUrl,
//             fit: BoxFit.cover,
//           ),
//         ),
//         footer: GridTileBar(
//           backgroundColor: Colors.black54,
//           leading: Consumer<Product>(
//             builder: (ctx, product, child) => IconButton(
//               icon: Icon(
//                 product.isFavorite ? Icons.favorite : Icons.favorite_border,
//               ),
//               color: Theme.of(context).accentColor,
//               onPressed: () {
//                 product.toggleFavoriteStatus(
//                   authData.token,
//                   authData.userId,
//                 );
//               },
//             ),
//           ),
//           title: Text(
//             product.price.toString(),
//             textAlign: TextAlign.center,
//           ),
//           trailing: IconButton(
//             icon: Icon(Icons.shopping_cart_outlined),
//             color: Theme.of(context).accentColor,
//             onPressed: () {
//               cart.addItem(
//                 product.id,
//                 product.price,
//                 product.title,
//               );
//               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Added item to cart!'),
//                   duration: Duration(seconds: 2),
//                   action: SnackBarAction(
//                     label: 'UNDO',
//                     onPressed: () {
//                       cart.removeSingleItem(product.id);
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
