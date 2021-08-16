import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './constants.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/districts.dart';
import './providers/order_details.dart';
import './providers/orders.dart';
import './providers/price_lists.dart';
import './providers/products.dart';
import './providers/provinces.dart';
import './providers/redeems.dart';
import './providers/regencies.dart';
import './providers/users.dart';
import './providers/visits.dart';
import './screens/auth_screen.dart';
import './screens/main_screen.dart';
import './screens/officer/officer_main_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/splash_screen.dart';
import './screens/visit_entry_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (_) => Users([]),
          update: (
            ctx,
            auth,
            prevUsers,
          ) =>
              Users(
            prevUsers == null ? [] : prevUsers.users,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products([]),
          update: (
            ctx,
            auth,
            prevProducts,
          ) =>
              Products(
            prevProducts == null ? [] : prevProducts.products,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders([]),
          update: (
            ctx,
            auth,
            prevOrders,
          ) =>
              Orders(
            prevOrders == null ? [] : prevOrders.orders,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderDetails>(
          create: (_) => OrderDetails([]),
          update: (
            ctx,
            auth,
            prevOrderDetails,
          ) =>
              OrderDetails(
            prevOrderDetails == null ? [] : prevOrderDetails.orderDetails,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart([]),
          update: (
            ctx,
            auth,
            prevCart,
          ) =>
              Cart(
            prevCart == null ? [] : prevCart.items,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Redeems>(
          create: (_) => Redeems([]),
          update: (
            ctx,
            auth,
            prevRedeems,
          ) =>
              Redeems(
            prevRedeems == null ? [] : prevRedeems.redeems,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Visits>(
          create: (_) => Visits([]),
          update: (
            ctx,
            auth,
            prevVisits,
          ) =>
              Visits(
            prevVisits == null ? [] : prevVisits.visits,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, PriceLists>(
          create: (_) => PriceLists([]),
          update: (
            ctx,
            auth,
            prevPriceLists,
          ) =>
              PriceLists(
            prevPriceLists == null ? [] : prevPriceLists.priceLists,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Provinces>(
          create: (_) => Provinces([]),
          update: (
            ctx,
            auth,
            prevProvinces,
          ) =>
              Provinces(
            prevProvinces == null ? [] : prevProvinces.provinces,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Regencies>(
          create: (_) => Regencies([]),
          update: (
            ctx,
            auth,
            prevRegencies,
          ) =>
              Regencies(
            prevRegencies == null ? [] : prevRegencies.regencies,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Districts>(
          create: (_) => Districts([]),
          update: (
            ctx,
            auth,
            prevDistricts,
          ) =>
              Districts(
            prevDistricts == null ? [] : prevDistricts.districts,
            token: auth.token,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kampoeng Kepiting',
          theme: ThemeData(
            primarySwatch: generateMaterialColor(primaryColor),
            accentColor: Colors.amberAccent,
            fontFamily: 'PTSans',
            scaffoldBackgroundColor: primaryBackgrounColor,
            appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: primaryBackgrounColor,
              centerTitle: true,
              elevation: 0,
              foregroundColor: primaryColor,
              iconTheme: IconThemeData(color: primaryColor),
              textTheme: TextTheme(
                headline6: TextStyle(
                  color: primaryColor,
                  fontFamily: 'PTSerif',
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            textTheme: ThemeData.light()
                .textTheme
                .copyWith(
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  bodyText2: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  headline6: TextStyle(
                    fontFamily: 'PTSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .apply(
                  displayColor: textColor,
                ),
          ),
          home: auth.isAuth
              ? (auth.activeUser!.level.contains('Admin') ||
                      auth.activeUser!.level.contains('Officer')
                  ? OfficerMainScreen()
                  : MainScreen())
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            VisitEntryScreen.routeName: (ctx) => VisitEntryScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (ctx) => MainScreen(),
          ),
        ),
      ),
    );
  }
}
