import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/visit.dart';
import '../../providers/visits.dart';
import '../../screens/common/visit_detail_screen.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class VisitItem extends StatefulWidget {
  final Visit visitData;
  final int visitNo;
  final Function showVisitQr;
  VisitItem(this.visitData, this.visitNo, this.showVisitQr, {Key? key})
      : super(key: key);

  @override
  _VisitItemState createState() => _VisitItemState();
}

class _VisitItemState extends State<VisitItem> {
  final now = DateTime.now();

  Future<void> _deleteVisit(int visitId) async {
    await Provider.of<Visits>(context, listen: false).deleteVisit(visitId);
  }

  @override
  Widget build(BuildContext context) {
    final visit = widget.visitData;
    final visitDate = DateTime(
      visit.created!.year,
      visit.created!.month,
      visit.created!.day,
    );

    final today = DateTime(now.year, now.month, now.day);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(large),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryBackgrounColor,
          child: Text((widget.visitNo).toString()), // Icon(Icons.qr_code),
        ),
        title: Text(
          DateFormat('dd MMMM yyyy').format(visit.created!),
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(visit.region),
        trailing: visitDate.isAtSameMomentAs(today) && visit.visitTime == null
            ? IconButton(
                onPressed: () => widget.showVisitQr(visit.visitCode),
                icon: Icon(
                  Icons.qr_code,
                  color: primaryColor,
                ),
              )
            : IconButton(
                onPressed: null,
                icon: Icon(Icons.qr_code),
              ),
        onTap: () {
          Navigator.of(context).pushNamed(
            VisitDetailScreen.routeName,
            arguments: visit.id,
          );
        },
        onLongPress: () async {
          if (visit.visitTime == null)
            MessageDialog.showMessageDialog(
              context,
              'Delete Visit Data',
              'Are you sure to delete visit data ${visit.region}',
              'Sure',
              _deleteVisit,
              args: visit.id,
            );
        },
      ),
    );
  }
}
