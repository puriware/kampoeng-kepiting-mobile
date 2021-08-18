import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/user.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../providers/visits.dart';
import '../../widgets/message_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({Key? key}) : super(key: key);

  @override
  _VisitorScreenState createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  User? _officerAccount;
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _officerAccount = Provider.of<Auth>(context, listen: false).activeUser;
      await Provider.of<Users>(context, listen: false).fetchAndSetUsers();
      await _fetchVisitorData();
      _isInit = false;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _fetchVisitorData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Visits>(context, listen: false).fetchAndSetVisits(
        //officerId: _officerAccount != null ? _officerAccount!.id : null,
        );
    setState(() {
      _isLoading = false;
    });
  }

  void _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      var result = barcode.trim().replaceAll('\n', '').replaceAll('\t', '');
      _saveVisit(result);
    }
  }

  _saveVisit(String? visitCode) async {
    if (visitCode != null && visitCode.isNotEmpty && _officerAccount != null) {
      try {
        print(visitCode);
        final visitData = Provider.of<Visits>(context, listen: false)
            .getVisitByCode(visitCode);
        if (visitData != null) {
          visitData.officer = _officerAccount!.id;
          visitData.visitTime = DateTime.now();
          final updateResult = await Provider.of<Visits>(context, listen: false)
              .updateVisit(visitData);
          MessageDialog.showPopUpMessage(
            context,
            'Visitor Report',
            updateResult,
          );
        } else {
          MessageDialog.showPopUpMessage(
            context,
            "Invalid Visit",
            'Visit data is invalid',
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
    final visitData = Provider.of<Visits>(context)
        .getTodaysVisit(officerId: _officerAccount!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor Data'),
        actions: [IconButton(onPressed: _scan, icon: Icon(CupertinoIcons.add))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(medium),
              child: RefreshIndicator(
                onRefresh: _fetchVisitorData,
                child: ListView.builder(
                  itemBuilder: (ctx, idx) {
                    final visit = visitData[idx];
                    User? visitor = Provider.of<Users>(context, listen: false)
                        .getUserById(visit.visitor);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(large),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryBackgrounColor,
                          child: Text((visitData.length - idx)
                              .toString()), // Icon(Icons.qr_code),
                        ),
                        title: Text(
                          visitor != null
                              ? '${visitor.firstname} ${visitor.lastname}'
                              : visit.region,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        subtitle: Text(
                          DateFormat('dd MMMM yyyy').format(visit.visitTime!),
                        ),
                        trailing: Text(
                          DateFormat('HH:mm').format(visit.visitTime!),
                        ),
                      ),
                    );
                  },
                  itemCount: visitData.length,
                ),
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(CupertinoIcons.qrcode_viewfinder),
      //   onPressed: _scan,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
