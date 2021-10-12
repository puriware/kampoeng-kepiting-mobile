import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    Key? key,
    required this.paymentIndex,
  }) : super(key: key);

  final int paymentIndex;

  @override
  Widget build(BuildContext context) {
    final payment = PAYMENT[paymentIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: large,
        vertical: medium,
      ),
      child: Row(
        children: [
          Container(
            width: 96,
            height: 50,
            child: SvgPicture.asset(
              payment.providerLogo,
              semanticsLabel: '${payment.accountName.toUpperCase()} Logo',
            ),
          ),
          SizedBox(
            width: large,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.provider.toUpperCase(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  payment.accountID,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(payment.accountName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
