import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/screens/visitor/payment_screen.dart';
import '../../../providers/orders.dart';
import '../../../screens/common/account_edit_screen.dart';
import '../../../screens/visitor/order_screen.dart';
import '../../../constants.dart';
import '../../../providers/auth.dart';
import '../../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class SettingModel {
  String title;
  String subTitle;
  Function onPressed;

  SettingModel({
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final userData = Provider.of<Auth>(context, listen: false).activeUser!;
    final totalPurchase = Provider.of<Orders>(context).orderCount;
    int itemNo = 0;
    List<SettingModel> settings = [
      SettingModel(
        title: 'Account',
        subTitle: 'Update profile & password',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contex) => AccountEditScreen(),
            ),
          );
        },
      ),
      if (userData.level == 'Customer')
        SettingModel(
          title: 'Purchase History',
          subTitle: '$totalPurchase Purchase',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (contex) => OrderScreen(),
              ),
            );
          },
        ),
      SettingModel(
        title: 'About',
        subTitle: 'About Kampoeng Kepiting Mobile',
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(appName),
                content: Text(
                    'Kampoeng Kepiting adalah sebuah merk dagang dari Kelompok Nelayan Wanasari Tuban'),
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
        },
      ),
      SettingModel(
        title: 'Logout',
        subTitle: 'Delete your user data',
        onPressed: () async {
          await MessageDialog.showMessageDialog(
            context,
            'Logout',
            'Are you sure you want to logout?',
            'Logout',
            () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: large),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: deviceSize.width * 0.3,
                width: deviceSize.width * 0.3,
                child: CircleAvatar(
                  child: userData.picture.isEmpty
                      ? Icon(
                          Icons.account_circle_rounded,
                          size: deviceSize.width * 0.35,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : ClipOval(
                          child: Image.network(
                            userData.picture,
                            fit: BoxFit.fill,
                          ),
                        ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                height: medium,
              ),
              Text(
                '${userData.firstname.toString()} ${userData.lastname.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: small,
              ),
              Text(
                userData.level,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: large,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: medium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ...settings.map((setting) {
                      itemNo += 1;
                      return InkWell(
                        onTap: () => setting.onPressed(),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                setting.title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              subtitle: Text(setting.subTitle),
                              trailing: IconButton(
                                onPressed: () => setting.onPressed(),
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                ),
                              ),
                            ),
                            if (itemNo < settings.length)
                              Divider(
                                thickness: 1,
                                indent: large,
                                endIndent: large,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(
                height: large,
              ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   child: ElevatedButton(
    //     onPressed: () {
    //       Provider.of<Auth>(context, listen: false).logOut();
    //     },
    //     child: Text('Logout'),
    //   ),
    // );
  }
}
