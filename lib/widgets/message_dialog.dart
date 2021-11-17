import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class MessageDialog {
  static Future<void> showPopUpMessage(
    BuildContext context,
    String title,
    String content,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showMessageDialog(
    BuildContext context,
    String title,
    String content,
    String action,
    Function callBack, {
    Object? args,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(action),
              onPressed: () {
                Navigator.of(context).pop();
                if (args != null)
                  callBack(args);
                else
                  callBack();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showQrDialog(
    BuildContext context,
    String title,
    String qrContent,
  ) async {
    Uint8List content = await scanner.generateBarCode(
      qrContent,
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(content),
              SizedBox(
                height: large,
              ),
              Container(
                padding: EdgeInsets.all(large),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      large,
                    ),
                  ),
                  color: primaryColor,
                ),
                child: Text(
                  qrContent,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
        );
      },
    );
  }
}
