import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../widgets/visit_item.dart';
import '../../constants.dart';
import '../../models/visit.dart';
import '../../providers/auth.dart';
import '../../providers/visits.dart';
import '../../widgets/message_dialog.dart';
import '../../widgets/visit_entry_modal.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
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
              child: _visitListView(_onlyTodays),
            ),
    );
  }

  Widget _visitListView(bool onlyTodays) {
    final visit = Provider.of<Visits>(context);
    final visitData = onlyTodays ? visit.getTodaysVisit() : visit.visits;
    return Padding(
      padding: const EdgeInsets.all(medium),
      child: GroupedListView<Visit, String>(
        elements: visitData,
        groupBy: (visit) => visit.created!.toIso8601String().substring(0, 10),
        floatingHeader: true,
        useStickyGroupSeparators: true,
        order: GroupedListOrder.DESC,
        groupSeparatorBuilder: (String groupValue) => Container(
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(small),
                child: Text(
                  '${DateFormat('dd MMM yyyy').format(DateTime.parse(groupValue))}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        indexedItemBuilder: (ctx, visit, idx) => VisitItem(
          visit.id,
          visitData.length - idx,
        ),
      ),
    );
  }
}
