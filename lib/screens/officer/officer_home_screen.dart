import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../providers/visits.dart';
import '../../widgets/product_weekly_pie_chart.dart';
import '../../widgets/user_profile.dart';
import '../../widgets/weekly_chart.dart';
import 'package:provider/provider.dart';

class OfficerHomeScreen extends StatelessWidget {
  const OfficerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thisWeekTotalVisitor =
        Provider.of<Visits>(context).thisWeekTotalVisit;
    final lastWeekTotalVisitor =
        Provider.of<Visits>(context, listen: false).prevWeekTotalVisit;
    final percentageFromLastWeek =
        thisWeekTotalVisitor / lastWeekTotalVisitor * 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(appName),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: large),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserProfile(),
              SizedBox(
                height: large,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 21),
                      blurRadius: large,
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Today's Visitor",
                      style: TextStyle(
                        color: kTextMediumColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: medium),
                    Text(
                      Provider.of<Visits>(context).todaysTotalVisit.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: primaryColor, height: 1.2),
                    ),
                    SizedBox(height: medium),
                    Text(
                      "This Week\'s Visitor",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: kTextMediumColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: medium),
                    WeeklyChart(),
                    SizedBox(height: medium),
                    buildInfoTextWithPercentage(
                      percentage: percentageFromLastWeek.toStringAsFixed(2),
                      title: "From Last Week",
                    ),
                  ],
                ),
              ),
              SizedBox(height: large),
              ProductWeeklyPieChart(),
              SizedBox(height: large),
            ],
          ),
        ),
      ),
    );
  }

  RichText buildInfoTextWithPercentage(
      {required String title, required String percentage}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$percentage% \n",
            style: TextStyle(
              fontSize: 20,
              color: primaryColor,
            ),
          ),
          TextSpan(
            text: title,
            style: TextStyle(
              color: kTextMediumColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
