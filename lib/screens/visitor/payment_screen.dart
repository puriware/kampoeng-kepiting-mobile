import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/order.dart';
import 'package:kampoeng_kepiting_mobile/providers/orders.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import 'package:kampoeng_kepiting_mobile/widgets/order_list.dart';
import 'package:kampoeng_kepiting_mobile/widgets/payment_item.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var selectedPayment = PAYMENT[0].accountID;

  void _savePayment(Order order) async {
    try {
      await Provider.of<Orders>(context, listen: false).updateOrder(order);
      await MessageDialog.showPopUpMessage(context, 'Payment Result',
          'Your payment is being processed, please wait for the verification process.');
      Navigator.of(context).pop();
    } catch (err) {
      MessageDialog.showPopUpMessage(
        context,
        'Payment Error',
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as int;
    final order =
        Provider.of<Orders>(context, listen: false).getOrderById(orderId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 95.0 * PAYMENT.length, //min(95.0 * PAYMENT.length, 380),
              margin: EdgeInsets.fromLTRB(large, 0, large, large),
              padding: EdgeInsets.symmetric(vertical: large),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    large,
                  ),
                ),
              ),
              child: ListView.builder(
                itemCount: PAYMENT.length,
                itemBuilder: (ctx, idx) {
                  return Column(
                    children: [
                      PaymentItem(paymentIndex: idx),
                      if (idx < PAYMENT.length - 1)
                        Divider(
                          indent: large,
                          endIndent: large,
                        ),
                    ],
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(large, 0, large, large),
              padding: EdgeInsets.all(large),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    large,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Order Details',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: medium,
                  ),
                  OrderList(orderId),
                  Divider(),
                  if (order != null)
                    Text(
                      'Total Payment: ${currency.format(order.grandTotal)}',
                      textAlign: TextAlign.end,
                    ),
                  Divider(),
                  SizedBox(
                    height: large,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedPayment,
                          decoration: InputDecoration(
                            labelText: 'Choose Payment Method',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.payment),
                            helperText: selectedPayment,
                          ),
                          style: const TextStyle(color: Colors.deepPurple),
                          icon: Icon(Icons.arrow_drop_down_circle_rounded),
                          items:
                              PAYMENT.map<DropdownMenuItem<String>>((payment) {
                            return DropdownMenuItem<String>(
                              value: payment.accountID,
                              child: Text(payment.provider),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedPayment = value.toString();
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            new ClipboardData(text: selectedPayment),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'The selected payment account has been copied to the clipboard.',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: large,
                  ),
                  Container(
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (order != null) {
                          final selectedBank = PAYMENT.firstWhere((element) =>
                              element.accountID == selectedPayment);
                          order.bankName = selectedBank.provider;
                          await MessageDialog.showMessageDialog(
                            context,
                            'Payment Confirmation',
                            'Have you chosen the correct payment method and made a payment of ${currency.format(order.grandTotal)}?',
                            'Yes',
                            () {
                              _savePayment(order);
                            },
                          );
                        }
                      },
                      child: Text('Process Payment'),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        backgroundColor:
                            primaryColor, // Theme.of(context).primaryColor,
                        primary: whiteBackgrounColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
