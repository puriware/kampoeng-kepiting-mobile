import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/providers/districts.dart';
import 'package:kampoeng_kepiting_mobile/providers/provinces.dart';
import 'package:kampoeng_kepiting_mobile/providers/regencies.dart';
import 'package:kampoeng_kepiting_mobile/providers/users.dart';
import 'package:kampoeng_kepiting_mobile/providers/visits.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class VisitDetailScreen extends StatelessWidget {
  static const routeName = '/visit-detail';
  const VisitDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final visitId = ModalRoute.of(context) != null
        ? ModalRoute.of(context)!.settings.arguments as int
        : -1;
    final visitData =
        Provider.of<Visits>(context, listen: false).getVisitById(visitId);
    final userData = visitData != null
        ? Provider.of<Users>(context, listen: false)
            .getUserById(visitData.visitor)
        : null;
    final proviceData = Provider.of<Provinces>(context, listen: false)
        .getProvinceById(visitData!.province.toString());
    print(proviceData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Detail'),
      ),
      body: visitData != null && userData != null
          ? Container(
              padding: EdgeInsets.all(large),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: deviceSize.width * 0.4,
                      width: deviceSize.width * 0.4,
                      child: CircleAvatar(
                        child: userData.picture.isEmpty
                            ? Icon(
                                Icons.person,
                                size: deviceSize.width * 0.35,
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
                    ),
                    SizedBox(
                      height: small,
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy').format(visitData.created!),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: large,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Province'),
                            Text('Regency'),
                            Text('District'),
                            Text('Region'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(' : '),
                            Text(' : '),
                            Text(' : '),
                            Text(' : '),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(visitData.province != null
                                ? Provider.of<Provinces>(context, listen: false)
                                            .getProvinceById(visitData.province
                                                .toString()) !=
                                        null
                                    ? Provider.of<Provinces>(context,
                                            listen: false)
                                        .getProvinceById(
                                            visitData.province.toString())!
                                        .name
                                    : ''
                                : ''),
                            Text(visitData.regency != null
                                ? Provider.of<Regencies>(context, listen: false)
                                            .getRegencyById(
                                                visitData.regency.toString()) !=
                                        null
                                    ? Provider.of<Regencies>(context,
                                            listen: false)
                                        .getRegencyById(
                                            visitData.regency.toString())!
                                        .name
                                    : ''
                                : ''),
                            Text(visitData.district != null
                                ? Provider.of<Districts>(context, listen: false)
                                            .getDistrictById(visitData.district
                                                .toString()) !=
                                        null
                                    ? Provider.of<Districts>(context,
                                            listen: false)
                                        .getDistrictById(
                                            visitData.district.toString())!
                                        .name
                                    : ''
                                : ''),
                            Text(visitData.region),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: large,
                    ),
                    FutureBuilder(
                        future: scanner.generateBarCode(visitData.visitCode),
                        builder: (ctx, AsyncSnapshot<Uint8List> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          if (snapshot.hasData) {
                            return Center(
                              child: Container(
                                height: deviceSize.width * 0.5,
                                width: deviceSize.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(32),
                                  ),
                                ),
                                padding: EdgeInsets.all(large),
                                child: Image.memory(snapshot.data!),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              ),
            )
          : Center(
              child: Text('Visit not found'),
            ),
    );
  }
}
