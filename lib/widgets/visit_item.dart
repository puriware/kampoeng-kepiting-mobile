import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/providers/regencies.dart';
import '../../constants.dart';
import '../../providers/visits.dart';
import '../../screens/common/visit_detail_screen.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class VisitItem extends StatelessWidget {
  final int visitId;
  final int visitNo;
  VisitItem(this.visitId, this.visitNo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Visits>(
      builder: (ctx, vst, _) {
        final visit = vst.getVisitById(visitId);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        if (visit != null) {
          final createdDate = DateTime(
            visit.created!.year,
            visit.created!.month,
            visit.created!.day,
          );
          final regency = visit.regency != null
              ? Provider.of<Regencies>(context)
                  .getRegencyById(visit.regency!)!
                  .name
              : '';
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(large),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryBackgrounColor,
                child: Text((visitNo).toString()), // Icon(Icons.qr_code),
              ),
              title: Text(
                //DateFormat('dd MMMM yyyy').format(visit.created!),
                visit.region,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(regency),
              trailing:
                  createdDate.isAtSameMomentAs(today) && visit.visitTime == null
                      ? IconButton(
                          onPressed: () async {
                            await MessageDialog.showQrDialog(
                              context,
                              "Visit QR Code",
                              visit.visitCode.toString(),
                            );
                            await Provider.of<Visits>(context, listen: false)
                                .fetchVisitById(visitId);
                          },
                          icon: Icon(
                            Icons.qr_code,
                            color: primaryColor,
                          ),
                        )
                      : IconButton(
                          onPressed: null,
                          icon: Icon(Icons.qr_code),
                        ),
              onTap: () async {
                await Navigator.of(context).pushNamed(
                  VisitDetailScreen.routeName,
                  arguments: visit.id,
                );
                await Provider.of<Visits>(context, listen: false)
                    .fetchVisitById(visitId);
              },
              onLongPress: () async {
                if (visit.visitTime == null)
                  MessageDialog.showMessageDialog(
                    context,
                    'Delete Visit Data',
                    'Are you sure to delete visit data ${visit.region}',
                    'Sure',
                    () async {
                      await Provider.of<Visits>(context, listen: false)
                          .deleteVisit(visitId);
                    },
                  );
              },
            ),
          );
        } else
          return Container();
      },
    );
  }
}
