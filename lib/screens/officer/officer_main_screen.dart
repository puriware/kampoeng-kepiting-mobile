import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/providers/users.dart';
import '../../constants.dart';
import '../../providers/order_details.dart';
import '../../providers/price_lists.dart';
import '../../providers/products.dart';
import '../../providers/redeems.dart';
import '../../providers/visits.dart';
import '../common/account_screen.dart';
import '../../screens/officer/officer_home_screen.dart';
import '../../screens/officer/redeem_screen.dart';
import '../../screens/officer/visitor_screen.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class OfficerMainScreen extends StatefulWidget {
  const OfficerMainScreen({Key? key}) : super(key: key);

  @override
  _OfficerMainScreenState createState() => _OfficerMainScreenState();
}

class _OfficerMainScreenState extends State<OfficerMainScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': OfficerHomeScreen(),
      'title': 'Kampoeng Kepiting',
    },
    {
      'page': VisitorScreen(),
      'title': 'Visitor List',
    },
    {
      'page': RedeemScreen(),
      'title': 'Redeem Voucher',
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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Products>(
          context,
          listen: false,
        ).fetchAndSetProducts();
        await Provider.of<PriceLists>(
          context,
          listen: false,
        ).fetchAndSetPriceLists();
        await Provider.of<OrderDetails>(
          context,
          listen: false,
        ).fetchAndSetOrderDetails();
        await Provider.of<Redeems>(
          context,
          listen: false,
        ).fetchAndSetRedeems();
        await Provider.of<Visits>(
          context,
          listen: false,
        ).fetchAndSetVisits();
        await Provider.of<Users>(
          context,
          listen: false,
        ).fetchAndSetUsers();
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
            icon: Icon(Icons.person_pin_circle_rounded),
            title: Text('Visitor'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.local_activity_rounded),
            title: Text('Redeem'),
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
