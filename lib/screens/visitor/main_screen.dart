import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
import '../../providers/order_details.dart';
import '../../providers/orders.dart';
import '../../providers/price_lists.dart';
import '../../providers/products.dart';
import '../../providers/redeems.dart';
import '../common/account_screen.dart';
import './home_screen.dart';
import './shop_screen.dart';
import './visit_list_screen.dart';
import './voucher_list_screen.dart';
import '../../widgets/message_dialog.dart';
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
      'page': VoucherListScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
