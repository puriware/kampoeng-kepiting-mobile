import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/product.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/products.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';

class VoucherItem extends StatelessWidget {
  final int orderDetailId;
  const VoucherItem(this.orderDetailId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _orderDetail = Provider.of<OrderDetails>(
      context,
    ).getOrderDetailById(orderDetailId);
    Product? _product;
    if (_orderDetail != null) {
      _product = Provider.of<Products>(
        context,
        listen: false,
      ).getProductById(_orderDetail.idProduct);
    }
    return _product != null && _orderDetail != null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(large),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: medium,
            ),
            child: Row(
              children: [
                _product.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            large,
                          ),
                          bottomLeft: Radius.circular(
                            large,
                          ),
                        ),
                        child: Image.network(
                          '$imageUrl${_product.image.toString()}.jpg',
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
                        FittedBox(
                          child: Text(
                            convertToTitleCase(
                              _product.name.trim(),
                            ),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${_orderDetail.remaining} from ${_orderDetail.quantity} voucher available'),
                                Text(
                                  'Voucher Code: ${_orderDetail.voucherCode.toString()}',
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _orderDetail.remaining > 0
                        ? IconButton(
                            onPressed: () async {
                              Uint8List qrcode = await scanner.generateBarCode(
                                _orderDetail.voucherCode.toString(),
                              );
                              await MessageDialog.showQrDialog(
                                context,
                                "Voucher QR Code",
                                qrcode,
                              );
                              await Provider.of<OrderDetails>(context,
                                      listen: false)
                                  .fetchOrderDetailById(orderDetailId);
                            },
                            icon: Icon(
                              Icons.qr_code,
                              color: primaryColor,
                            ),
                          )
                        : IconButton(
                            onPressed: null,
                            icon: Icon(Icons.qr_code),
                          ),
                  ),
                )
              ],
            ),
          )
        : Center();
  }
}
