import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../providers/auth.dart';
import '../../../widgets/adaptive_flat_button.dart';
import '../../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final userData = Provider.of<Auth>(context, listen: false).activeUser!;
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
                          Icons.person,
                          size: deviceSize.width * 0.4,
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Accout'),
                      subtitle: Text('Update profile & password'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('History Transaction'),
                      subtitle: Text('8 Purchase'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: large,
              ),
              AdaptiveFlatButton(
                'About',
                () {
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
                null,
                Icon(Icons.info_rounded),
              ),
              SizedBox(
                height: medium,
              ),
              AdaptiveFlatButton(
                'Logout',
                () async {
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
                Colors.red,
                Icon(Icons.logout),
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
