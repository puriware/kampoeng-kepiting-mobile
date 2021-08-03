import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/providers/visits.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class VisitListScreen extends StatelessWidget {
  const VisitListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final _visitData = Provider.of<Visits>(context).visits;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(large),
          topRight: Radius.circular(large),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: small,
        vertical: 0,
      ),
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          final visit = _visitData[idx];
          final visitDate = DateTime(
            visit.created!.year,
            visit.created!.month,
            visit.created!.day,
          );
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(large),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryBackgrounColor,
                child: Text((_visitData.length - idx)
                    .toString()), // Icon(Icons.qr_code),
              ),
              title: Text(
                DateFormat('dd MMMM yyyy').format(visit.created!),
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(visit.region),
              trailing: visitDate == today
                  ? IconButton(
                      onPressed: () async {
                        Uint8List qrcode =
                            await scanner.generateBarCode(visit.visitCode);
                        MessageDialog.showQrDialog(
                          context,
                          "Visit QR Code",
                          qrcode,
                        );
                      },
                      icon: Icon(
                        Icons.qr_code,
                        color: primaryColor,
                      ),
                    )
                  : Icon(Icons.qr_code),
            ),
          );
        },
        itemCount: _visitData.length,
      ),
    );
  }
}
