import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../widgets/visit_item.dart';
import '../../constants.dart';
import '../../models/visit.dart';
import '../../providers/auth.dart';
import '../../providers/visits.dart';
import '../../widgets/message_dialog.dart';
import '../../widgets/visit_entry_modal.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

enum FilterOptions {
  Todays,
  All,
}

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({Key? key}) : super(key: key);

  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  var _isLoading = false;
  var _isInit = true;
  var _onlyTodays = true;
  int? _userID;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      _userID = Provider.of<Auth>(context, listen: false).activeUser!.id;

      await _fetchVisitData();
      _isInit = false;
    }
  }

  Future<void> _fetchVisitData() async {
    setState(() {
      _isLoading = true;
    });
    if (_userID != null)
      await Provider.of<Visits>(context, listen: false)
          .fetchAndSetVisits(userId: _userID);
    setState(() {
      _isLoading = false;
    });
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
    await _fetchVisitData();
  }

  @override
  Widget build(BuildContext context) {
    final visitData = Provider.of<Visits>(context);

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
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Todays) {
                  _onlyTodays = true;
                } else {
                  _onlyTodays = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Todays'),
                value: FilterOptions.Todays,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchVisitData,
              child: _visitListView(
                context,
                _onlyTodays ? visitData.getTodaysVisit() : visitData.visits,
              ),
            ),
    );
  }

  Widget _visitListView(
    BuildContext context,
    List<Visit> visitData,
  ) {
    return Padding(
      padding: const EdgeInsets.all(medium),
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          final visit = visitData[idx];
          return VisitItem(visit, visitData.length - idx, _showVisitQr);
        },
        itemCount: visitData.length,
      ),
    );
  }
}
