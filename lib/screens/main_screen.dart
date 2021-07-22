import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/screens/account_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/home_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/product_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/visit_list_screen.dart';
import 'package:kampoeng_kepiting_mobile/screens/voucher_screen.dart';

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
      'page': ProductScreen(),
      'title': 'Activities',
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
  bool _isLoading = false;

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
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'].toString(),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _selectPage,
            children: _pages.map((page) => page['page'] as Widget).toList(),
          ),
          _isLoading
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
              : Container(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) {
          _selectPage(index);
          _pageController.jumpToPage(index);
        },
        selectedIndex: _selectedPageIndex,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home_rounded),
            title: Text('Home'),
            activeColor: primaryColor,
            inactiveColor: inactiveColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.festival_rounded),
            title: Text('Activity'),
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
