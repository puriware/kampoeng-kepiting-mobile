import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/product.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/screens/visitor/product_detail_screen.dart';
import '../../providers/products.dart';
import 'package:provider/provider.dart';

class OrderDetailItem extends StatelessWidget {
  final int orderDetailId;
  const OrderDetailItem(
    this.orderDetailId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderDetail = Provider.of<OrderDetails>(
      context,
    ).getOrderDetailById(orderDetailId);
    Product? product;
    if (orderDetail != null) {
      product = Provider.of<Products>(
        context,
        listen: false,
      ).getProductById(orderDetail.idProduct);
    }

    return product != null && orderDetail != null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(small),
              ),
              border: Border.all(width: 0.25),
            ),
            margin: EdgeInsets.only(
              bottom: medium,
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
                  product.image != null
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
                            convertToTitleCase(
                              product.name.toString().trim().length > 25
                                  ? product.name
                                      .toString()
                                      .trim()
                                      .substring(0, 25)
                                  : product.name.toString().trim(),
                            ),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${orderDetail.quantity} x ${orderDetail.price}'),
                                  Text(
                                    'Total ${currency.format((orderDetail.price * orderDetail.quantity))}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
