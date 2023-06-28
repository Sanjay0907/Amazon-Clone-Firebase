import 'package:amazon/view/seller/inventory/inventory_screen.dart';
import 'package:amazon/view/user/cart/cart_screen.dart';
import 'package:amazon/view/user/home/home_screen.dart';
import 'package:amazon/view/user/menu/menu_screen.dart';
import 'package:amazon/view/user/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../../utils/colors.dart';
import '../monitor/monitor_screen.dart';

class SellerBottomNavBar extends StatefulWidget {
  const SellerBottomNavBar({super.key});

  @override
  State<SellerBottomNavBar> createState() => _SellerBottomNavBarState();
}

class _SellerBottomNavBarState extends State<SellerBottomNavBar> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [InventoryScreen(), MonitorScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.inventory_2_outlined),
        title: "Inventory",
        activeColorPrimary: teal,
        inactiveColorPrimary: black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bar_chart_outlined),
        title: "Monitor",
        activeColorPrimary: teal,
        inactiveColorPrimary: black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
