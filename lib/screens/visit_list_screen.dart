import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/visit.dart';
import '../../providers/auth.dart';
import '../../providers/districts.dart';
import '../../providers/provinces.dart';
import '../../providers/regencies.dart';
import '../../providers/visits.dart';
import '../../widgets/message_dialog.dart';
import '../../widgets/visit_entry_modal.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({Key? key}) : super(key: key);

  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  var _isLoading = false;
  var _isInit = true;
  int? _userID;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      _userID = Provider.of<Auth>(context, listen: false).activeUser!.id;
      await Provider.of<Provinces>(context, listen: false)
          .fetchAndSetProvinces();
      await Provider.of<Regencies>(context, listen: false)
          .fetchAndSetRegencies();
      await Provider.of<Districts>(context, listen: false)
          .fetchAndSetDistricts();
      _isInit = false;
    }
  }

  Future<void> _fetchVisitData() async {
    if (_userID != null)
      await Provider.of<Visits>(context, listen: false)
          .fetchAndSetVisits(userId: _userID);
  }

  void _saveVisit(
    String region,
    String? province,
    String? regency,
    String? district,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (region.isNotEmpty) {
        final newVisit = Visit(
          visitor: _userID!,
          region: region,
          visitCode: '${_userID!}#${await nanoid()}',
          province: province,
          regency: regency,
          district: district,
        );

        final result = await Provider.of<Visits>(
          context,
          listen: false,
        ).addVisit(newVisit);

        MessageDialog.showPopUpMessage(context, 'Add visit result', result);
        setState(() {
          _isLoading = false;
        });
        //Navigator.of(context).pop();
      } else {
        MessageDialog.showPopUpMessage(
          context,
          'Region is empty',
          'Please insert your origin region',
        );
      }
    } catch (error) {
      MessageDialog.showPopUpMessage(
        context,
        "Error",
        error.toString(),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _showVisitQr(String code) async {
    Uint8List qrcode = await scanner.generateBarCode(code);
    await MessageDialog.showQrDialog(
      context,
      "Visit QR Code",
      qrcode,
    );
    _fetchVisitData();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: Text('Visit List'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(large),
                    topRight: Radius.circular(large),
                  ),
                ),
                context: context,
                builder: (_) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(large),
                      topRight: Radius.circular(large),
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: VisiEntryModal(_saveVisit),
                      behavior: HitTestBehavior.opaque,
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: _fetchVisitData(),
              builder: (ctx, snapshot) => RefreshIndicator(
                onRefresh: _fetchVisitData,
                child: Consumer<Visits>(
                  builder: (ctx, visitData, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemBuilder: (ctx, idx) {
                        final visit = visitData.visits[idx];
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
                              child: Text((visitData.visits.length - idx)
                                  .toString()), // Icon(Icons.qr_code),
                            ),
                            title: Text(
                              DateFormat('dd MMMM yyyy').format(visit.created!),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            subtitle: Text(visit.region),
                            trailing:
                                visitDate == today && visit.visitTime == null
                                    ? IconButton(
                                        onPressed: () =>
                                            _showVisitQr(visit.visitCode),
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
                      itemCount: visitData.visits.length,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
