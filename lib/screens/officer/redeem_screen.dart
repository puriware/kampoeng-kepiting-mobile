import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/services/order_detail_api.dart';
import '../../constants.dart';
import '../../models/redeem.dart';
import '../../models/user.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/redeems.dart';
import '../../providers/users.dart';
import '../../widgets/message_dialog.dart';
import '../../widgets/redeem_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({Key? key}) : super(key: key);

  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  User? _officerAccount;
  TextEditingController _ctrlRedeemVoucher = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _officerAccount = Provider.of<Auth>(context, listen: false).activeUser;
  }

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   if (_isInit) {
  //     try {
  //       await _fetchRedeemData();
  //     } catch (err) {
  //       MessageDialog.showPopUpMessage(
  //         context,
  //         'Error',
  //         err.toString(),
  //       );
  //     }
  //     _isInit = false;
  //   }
  // }

  // Future _fetchRedeemData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await Provider.of<Redeems>(context, listen: false).fetchAndSetRedeems();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      var result = barcode.trim().replaceAll('\n', '').replaceAll('\t', '');
      _redeemVoucher(result);
    }
  }

  Future<void> _showRedeemVoucherDialog(
    BuildContext context,
    TextEditingController ctrl,
    String productName,
    String visitorName,
    String totalVoucher,
    String voucherCode,
  ) async {
    final initialAvailableVoucher = ctrl.text;
    final initialValue = int.parse(initialAvailableVoucher);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Redeem Voucher')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text('Voucher Code: $voucherCode'),
              ),
              Card(
                elevation: small,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(large),
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Visitor'),
                          Text('Product'),
                          Text('Quantity'),
                          Text('Remaining'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(': '),
                          Text(': '),
                          Text(': '),
                          Text(': '),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(child: Text(visitorName)),
                          FittedBox(
                            child: Text(
                              convertToTitleCase(
                                productName.toString().trim().length > 20
                                    ? productName
                                        .toString()
                                        .trim()
                                        .substring(0, 20)
                                    : productName.toString().trim(),
                              ),
                            ),
                          ),
                          Text(totalVoucher),
                          Text(initialAvailableVoucher),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: large,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () {
                        var value = int.parse(ctrl.text.toString());
                        if (value > 0) value--;
                        ctrl.text = value.toString();
                      },
                      icon: Icon(
                        CupertinoIcons.minus,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: medium,
                  ),
                  Flexible(
                    child: TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(90),
                          ),
                          // borderSide: BorderSide(
                          //   color: Colors.transparent,
                          // ),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: medium,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () {
                        var value = int.parse(ctrl.text.toString());
                        if (value < initialValue) value++;
                        ctrl.text = value.toString();
                      },
                      icon: Icon(
                        CupertinoIcons.add,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                ctrl.text = '';
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _redeemVoucher(String? voucherCode) async {
    if (voucherCode != null) {
      try {
        OrderDetailApi api = OrderDetailApi(
          Provider.of<Auth>(context, listen: false).token.toString(),
        );
        // final orderData = Provider.of<OrderDetails>(context, listen: false)
        //     .getOrderDetailByVoucherCode(voucherCode);
        final orderData =
            await api.findOrderDetailBy('voucherCode', voucherCode);
        if (orderData.isNotEmpty) {
          final order = orderData[0];
          final product = Provider.of<Products>(context, listen: false)
              .getProductById(order.idProduct);
          final visitor = Provider.of<Users>(context, listen: false)
              .getUserById(order.userId);
          _ctrlRedeemVoucher.text = order.remaining.toString();
          await _showRedeemVoucherDialog(
            context,
            _ctrlRedeemVoucher,
            product!.name,
            '${visitor!.firstname} ${visitor.lastname}',
            order.quantity.toString(),
            voucherCode,
          );
          if (_ctrlRedeemVoucher.text.isNotEmpty && _officerAccount != null) {
            final quantity = int.parse(_ctrlRedeemVoucher.text.trim());
            final newRedeem = Redeem(
              voucherCode: voucherCode,
              quantity: quantity,
              officer: _officerAccount!.id,
            );
            final result = await Provider.of<Redeems>(context, listen: false)
                .addRedeem(newRedeem);

            MessageDialog.showPopUpMessage(
              context,
              'Redeem Voucher',
              result,
            );
          }
        } else {
          MessageDialog.showPopUpMessage(
            context,
            "Invalid Voucher",
            'Voucher not valid',
          );
        }
      } catch (err) {
        MessageDialog.showPopUpMessage(
          context,
          "Error",
          err.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem Voucher'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.refresh_rounded,
            ),
          ),
          IconButton(
            onPressed: _scan,
            icon: Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(medium),
              child: RefreshIndicator(
                onRefresh: Provider.of<Redeems>(context, listen: false)
                    .fetchAndSetRedeems,
                child: Consumer<Redeems>(
                  builder: (ctx, rdm, _) {
                    final redeemData =
                        rdm.getTodaysRedeem(officerId: _officerAccount!.id);
                    return ListView.builder(
                      itemBuilder: (ctx, idx) {
                        final redeem = redeemData[idx];
                        return RedeemItem(redeem, redeemData.length - idx);
                      },
                      itemCount: redeemData.length,
                    );
                  },
                ),
              ),
            ),
    );
  }
}
