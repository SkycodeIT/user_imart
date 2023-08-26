import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/ui_section/customer/tabbar/home.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'category.dart';
import 'favourite_product_page.dart';
import 'offers.dart';
import 'orders_page.dart';

bool isback = true;

class BottomTabbar extends StatefulWidget {
  BottomTabbar({this.positionTab});
  final int? positionTab;

  @override
  _BottomTabbarState createState() => _BottomTabbarState();
}

class _BottomTabbarState extends State<BottomTabbar> {
  // CupertinoTabController _controller;
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _fillSingleTon();
  }

  int homePageLength = 4;
  // int menuLength = 0;
  Future<void> _fillSingleTon() async {
    setState(() {
      isback = false;
    });
    // if (tempVariables.userType == 'guest') homePageLength = 2;
    if (widget.positionTab == 0) {
      _controller = PersistentTabController(initialIndex: 0);
    } else if (widget.positionTab == 1) {
      _controller = PersistentTabController(initialIndex: 1);
    } else if (widget.positionTab == 2) {
      _controller = PersistentTabController(initialIndex: 2);
    } else if (widget.positionTab == 3) {
      _controller = PersistentTabController(initialIndex: 3);
    } else if (widget.positionTab == 4) {
      _controller = PersistentTabController(initialIndex: 4);
      // } else if (widget.positionTab == 2) {
      //   _controller = PersistentTabController(initialIndex: 2);
      // } else if (widget.positionTab == 3) {
      //   _controller = PersistentTabController(initialIndex: 3);
    } else {
      _controller = PersistentTabController(initialIndex: 0);
    }
  }

  // DateTime currentBackPressTime;
  // Future<bool> onWillPop() {
  //   if (isback) {
  //     return Future.value(true);
  //   } else {
  //     DateTime now = DateTime.now();
  //     if (currentBackPressTime == null ||
  //         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
  //       currentBackPressTime = now;
  //       ToastComponent.showDialog('Double Click to exit app', context,
  //           gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
  //       return Future.value(false);
  //     }
  //     return Future.value(true);
  //   }
  // }

  List<Widget> _buildScreens() {
    return [
      Home(),
      const ProductCategory(),
      const FavouriteProductPage(),
      OfferPage(),
      OrdersPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          // color: Color.fromRGBO(153, 153, 153, 1),
          color: _controller!.index == 0
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
          // height: 20,
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        title: ("Home"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        icon: Image.asset(
          ImagePath.icCategory,
          // Icons.home,
          color: _controller!.index == 1
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
          // color: Color.fromRGBO(153, 153, 153, 1),
          height: 20,
        ),
        title: ("Categories"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        icon: Icon(
          CupertinoIcons.heart,
          color: _controller!.index == 2
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
          // Color.fromRGBO(153, 153, 153, 1),
          // height: 20,
        ),
        title: "Favourite",
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        icon: Image.asset(
          ImagePath.icOffer,
          height: 25,
          color: _controller!.index == 3
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
        ),
        title: ("Offer"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        iconSize: 25,
        textStyle: const TextStyle(fontSize: 13),
        icon: Image.asset(
          ImagePath.icOrder,
          // height: 30,
          color: _controller!.index == 4
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
        ),
        title: ("Orders"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      onItemSelected: (c) {
        // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //   NoAnimationMaterialPageRoute(
        //       builder: (context) => BottomTabbar(
        //             positionTab: c,
        //           )),
        //   (route) => false,
        // );
        
        setState(() {});
      },
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 70,
      confineInSafeArea: true,
      bottomScreenMargin: 0,
      // padding: NavBarPadding.all(5),
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
