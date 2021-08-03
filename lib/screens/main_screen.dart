import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/models/visit.dart';
import 'package:kampoeng_kepiting_mobile/providers/auth.dart';
import 'package:kampoeng_kepiting_mobile/providers/order_details.dart';
import 'package:kampoeng_kepiting_mobile/providers/orders.dart';
import 'package:kampoeng_kepiting_mobile/providers/price_lists.dart';
import 'package:kampoeng_kepiting_mobile/providers/products.dart';
import 'package:kampoeng_kepiting_mobile/providers/redeems.dart';
import 'package:kampoeng_kepiting_mobile/providers/visits.dart';
import 'package:kampoeng_kepiting_mobile/screens/account_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/home_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/shop_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/visit_list_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/voucher_screen.dart';
import 'package:kampoeng_kepiting_mobile/widgets/message_dialog.dart';
import 'package:kampoeng_kepiting_mobile/widgets/visit_entry_modal.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': 'Kampoeng Kepiting',
    },
    {
      'page': ShopScreen(),
      'title': 'Shoping List',
    },
    {
      'page': VisitListScreen(),
      'title': 'Visit List',
    },
    {
      'page': VoucherScreen(),
      'title': 'Voucher List',
    },
    {
      'page': AccountScreen(),
      'title': 'My Account',
    },
  ];

  PageController _pageController = PageController();
  int _selectedPageIndex = 0;
  var _isInit = true;
  var _isLoading = false;
  int? _userID;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        _userID = Provider.of<Auth>(context, listen: false).activeUser!.id;
        await Provider.of<Products>(
          context,
          listen: false,
        ).fetchAndSetProducts();
        await Provider.of<PriceLists>(
          context,
          listen: false,
        ).fetchAndSetPriceLists();
        await Provider.of<Orders>(
          context,
          listen: false,
        ).fetchAndSetOrders(userId: _userID);
        await Provider.of<OrderDetails>(
          context,
          listen: false,
        ).fetchAndSetOrderDetails(userId: _userID);
        await Provider.of<Redeems>(
          context,
          listen: false,
        ).fetchAndSetRedeems();
        await Provider.of<Visits>(
          context,
          listen: false,
        ).fetchAndSetVisits(userId: _userID);
        _isInit = false;
      } catch (error) {
        MessageDialog.showPopUpMessage(
          context,
          "Error Loading Data",
          error.toString(),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _saveVisit(
    String region,
    String province,
    String regency,
    String district,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (region.isNotEmpty) {
        final newVisit = Visit(
          visitor: _userID!,
          region: region,
          visitCode: '${_userID!}#${nanoid()}',
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
        backgroundColor:
            _selectedPageIndex == 0 ? primaryColor : primaryBackgrounColor,
        foregroundColor:
            _selectedPageIndex == 0 ? primaryBackgrounColor : primaryColor,
        title: Text(
          _pages[_selectedPageIndex]['title'].toString(),
          style: TextStyle(
            color:
                _selectedPageIndex == 0 ? primaryBackgrounColor : primaryColor,
          ),
        ),
        actions: [
          if (_selectedPageIndex == 2)
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
          ? Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.3,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.grey,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          : PageView(
              controller: _pageController,
              onPageChanged: _selectPage,
              children: _pages.map((page) => page['page'] as Widget).toList(),
            ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) {
          _selectPage(index);
          _pageController.jumpToPage(index);
        },
        selectedIndex: _selectedPageIndex,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.festival_rounded),
            title: Text('Home'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_basket_rounded),
            title: Text('Shop'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person_pin_circle_rounded),
            title: Text('Visit'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.local_activity_rounded),
            title: Text('Voucher'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.account_circle_rounded),
            title: Text('Account'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }
}
