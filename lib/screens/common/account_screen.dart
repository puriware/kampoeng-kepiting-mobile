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
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: deviceSize.width * 0.5,
                width: deviceSize.width * 0.5,
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
                height: medium,
              ),
              Text(
                userData.level,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Spacer(),
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
