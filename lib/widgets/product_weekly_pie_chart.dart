import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/order_detail.dart';
import 'package:kampoeng_kepiting_mobile/models/product.dart';
import 'package:kampoeng_kepiting_mobile/providers/auth.dart';
import 'package:kampoeng_kepiting_mobile/providers/products.dart';
import 'package:kampoeng_kepiting_mobile/services/order_detail_api.dart';
import 'package:kampoeng_kepiting_mobile/widgets/indicator.dart';
import 'package:provider/provider.dart';

class ProductWeeklyPieChart extends StatefulWidget {
  const ProductWeeklyPieChart({Key? key}) : super(key: key);

  @override
  _ProductWeeklyPieChartState createState() => _ProductWeeklyPieChartState();
}

class _ProductWeeklyPieChartState extends State<ProductWeeklyPieChart> {
  int touchedIndex = -1;
  var today = DateTime.now();
  final _colors = [
    Color(0xFF4357ad),
    Color(0xFF48a9a6),
    Color(0xFFe4dfda),
    Color(0xFFd4b483),
    Color(0xFFc1666b),
    Color(0xFFfb3640),
    Color(0xFF605f5e),
    Color(0xFF247ba0),
    Color(0xFFe2e2e2),
    Color(0xFF083d77),
    Color(0xFFf4d35e),
    Color(0xFFee964b),
    Color(0xFFf95738),
  ];
  List<int> _totalVisitor = [];
  List<double> _percentageVisitor = [];
  List<String> _destinationName = [];
  var _isInit = true;
  var _isLoading = false;
  OrderDetailApi? _orderDetailApi;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _orderDetailApi =
          OrderDetailApi(Provider.of<Auth>(context, listen: false).token!);
      final end = DateTime(today.year, today.month, today.day);
      final start = end.add(Duration(days: -7));
      if (_orderDetailApi != null) {
        final result = await _orderDetailApi!.getRedeemedOrder(start, end);
        if (result.isNotEmpty) {
          _totalVisitor = result.map((order) => order.quantity).toList();
          _destinationName = result
              .map(
                (order) => convertToTitleCase(
                  Provider.of<Products>(context, listen: false)
                      .getProductById(order.idProduct)!
                      .name,
                ),
              )
              .toList();
          final total =
              _totalVisitor.reduce((value, element) => value + element);
          _percentageVisitor =
              _totalVisitor.map((order) => order / total * 100).toList();
        }
      }
      _isInit = false;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AspectRatio(
            aspectRatio: (11 - _destinationName.length) / 7,
            child: Container(
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
                    "Destination of the Week",
                    style: TextStyle(
                      color: kTextMediumColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: medium,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput
                                      is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      _destinationName.length,
                      (index) => Indicator(
                        color: _colors[index],
                        text: _destinationName[index],
                        isSquare: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            ),
          );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(_destinationName.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: _colors[i],
        value: _totalVisitor[i].toDouble(),
        title: '${_percentageVisitor[i].toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}
