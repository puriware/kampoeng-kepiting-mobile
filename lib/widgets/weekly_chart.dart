import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/visit.dart';
import 'package:kampoeng_kepiting_mobile/providers/visits.dart';
import 'package:provider/provider.dart';

class WeeklyChart extends StatelessWidget {
  final now = DateTime.now();
  List<Visit> thisWeekVisits = [];

  @override
  Widget build(BuildContext context) {
    thisWeekVisits = Provider.of<Visits>(context).thisWeekVisits;

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barGroups: getBarGroups(),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: getWeek,
              getTextStyles: getStyles,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle? getStyles(BuildContext ctx, double n) {
    return TextStyle(
      color: Color(0xFF7589A2),
      fontSize: 10,
      fontWeight: FontWeight.w200,
    );
  }

  getBarGroups() {
    List<double> barChartDatas =
        thisWeekVisits.isNotEmpty ? getTotalByDay() : [0, 0, 0, 0, 0, 0, 0];
    List<BarChartGroupData> barChartGroups = [];
    final weekday = DateTime.now().weekday;
    barChartDatas.asMap().forEach(
          (i, value) => barChartGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  y: value,
                  colors: i == weekday - 1 ? [primaryColor] : [inactiveColor],
                  width: 16,
                )
              ],
            ),
          ),
        );
    return barChartGroups;
  }

  List<double> getTotalByDay() {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final weekday = today.weekday;
    List<double> result = [];
    for (int i = (weekday - 1); i >= 0; i--) {
      final date = today.add(Duration(days: -i));
      final dateVisit = [
        ...thisWeekVisits
            .where((element) =>
                element.visitTime!.year == date.year &&
                element.visitTime!.month == date.month &&
                element.visitTime!.day == date.day)
            .toList()
      ];
      result.add(dateVisit.length.toDouble());
    }
    for (int j = (weekday + 1); j <= 7; j++) {
      result.add(0);
    }
    return result;
  }

  String getWeek(double value) {
    switch (value.toInt()) {
      case 0:
        return 'MON';
      case 1:
        return 'TUE';
      case 2:
        return 'WED';
      case 3:
        return 'THU';
      case 4:
        return 'FRI';
      case 5:
        return 'SAT';
      case 6:
        return 'SUN';
      default:
        return '';
    }
  }
}
