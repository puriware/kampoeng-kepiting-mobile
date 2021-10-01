import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
import '../../providers/order_details.dart';
import '../../providers/products.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

enum FilterOptions {
  Available,
  All,
}

class VoucherListScreen extends StatefulWidget {
  VoucherListScreen({Key? key}) : super(key: key);

  @override
  _VoucherListScreenState createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  var _isLoading = false;
  var _isInit = true;
  var _onlyAvailable = true;
  int? _userID;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      _userID = Provider.of<Auth>(context, listen: false).activeUser!.id;
      await _fetchVoucherData();
      _isInit = false;
    }
  }

  Future<void> _fetchVoucherData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<OrderDetails>(context, listen: false)
        .fetchAndSetOrderDetails(userId: _userID);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final voucher = Provider.of<OrderDetails>(context, listen: false);
    final voucherList =
        _onlyAvailable ? voucher.availableVoucher : voucher.voucherIssued;

    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher List'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Available) {
                  _onlyAvailable = true;
                } else {
                  _onlyAvailable = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Available'),
                value: FilterOptions.Available,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchVoucherData,
              child: Padding(
                padding: const EdgeInsets.all(medium),
                child: ListView.builder(
                  itemBuilder: (ctx, idx) {
                    final order = voucherList![idx];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(large),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryBackgrounColor,
                          child: Text(
                            (voucherList.length - idx).toString(),
                          ), // Icon(Icons.qr_code),
                        ),
                        title: FittedBox(
                          child: Text(
                            convertToTitleCase(
                              Provider.of<Products>(context, listen: false)
                                  .getProductById(order.idProduct)!
                                  .name
                                  .toString()
                                  .trim(),
                            ),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        subtitle: Text(
                            '${order.remaining} from ${order.quantity} voucher available'),
                        trailing: order.remaining > 0
                            ? IconButton(
                                onPressed: () async {
                                  Uint8List qrcode = await scanner
                                      .generateBarCode(order.voucherCode!);
                                  await MessageDialog.showQrDialog(
                                    context,
                                    "Voucher QR Code",
                                    qrcode,
                                  );
                                  await _fetchVoucherData();
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
                        onTap: () {},
                      ),
                    );
                  },
                  itemCount: voucherList != null ? voucherList.length : 0,
                ),
              ),
            ),
    );
  }
}
