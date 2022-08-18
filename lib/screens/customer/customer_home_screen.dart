import 'package:flutter/material.dart';
import 'package:project/constants/constants.dart';
import 'package:project/screens/customer/browse_books.dart';
import 'package:project/screens/customer/cart_screen.dart';
import 'package:project/screens/customer/custom_animated_bottom_nav.dart';
import 'package:project/screens/customer/customer_profile.dart';

TextEditingController searchController = TextEditingController();

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  bool isNight = false;
  final _inactiveColor = Colors.grey[700];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // leading: Builder(
      //     builder: (BuildContext context) => IconButton(
      //         icon: const Icon(
      //           Icons.menu,
      //           color: Colors.black,
      //         ),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         })),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         setState(() {
      //           isNight = !isNight;
      //           SharedPreference sh = SharedPreference();
      //           sh.saveUserdata(false, "", false, "");
      //           Navigator.pushReplacementNamed(context, '/login');
      //         });
      //       },
      //       icon: isNight
      //           ? const Icon(Icons.sunny)
      //           : const Icon(Icons.wb_sunny_outlined),
      //       color: Colors.black,
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: getBody(),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      const BrowseBooks(),
      const CartScreen(),
      const Scaffold(),
      const CustomerProfile()
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

  Widget _buildBottomBar() {
    Color activeColor = Colors.lightBlueAccent;

    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.white,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text(
            'Home',
            style: kMediumTextStyle,
          ),
          activeColor: activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: const Text(
            'Cart ',
            style: kMediumTextStyle,
          ),
          activeColor: activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.menu_book),
          title: const Text(
            'My Library',
            style: kMediumTextStyle,
          ),
          activeColor: activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.settings),
          title: const Text(
            'Settings',
            style: kMediumTextStyle,
          ),
          activeColor: activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
