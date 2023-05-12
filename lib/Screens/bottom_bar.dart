import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shopping_app_flutter/Screens/search.dart';
import 'package:shopping_app_flutter/Screens/user_info.dart';

import 'cart/cart.dart';
import 'feeds.dart';
import 'home.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  List _pages;

  // var _pages;
  int _selectIndex = 0;

  @override
  void initState() {
    _pages = [
      Home(),
      Feeds(),
      Search(),
      Cart(),
      UserInfo(),
    ];
    super.initState();
  }

  void _selectPages(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(_pages[_selectIndex]['title']),
      // ),
      body: _pages[_selectIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          onTap: _selectPages,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textSelectionColor,
          selectedItemColor: Colors.blue,
          currentIndex: _selectIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Feather.home),
                label: 'Trang chủ'),
            BottomNavigationBarItem(
                icon: Icon(Feather.rss),
                label: 'Khám phá'),
            BottomNavigationBarItem(
                activeIcon: null, icon: Icon(null),
                label: 'Tìm kiếm'),
            BottomNavigationBarItem(
                icon: Icon(Feather.shopping_cart),
                label: 'Thanh toán'),
            BottomNavigationBarItem(
                icon: Icon(Feather.user),
                label: 'Thông tin'),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        hoverElevation: 10,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        child: (Icon(Feather.search)),
        onPressed: () {
          setState(() {
            _selectIndex = 2;
          });
        },
      ),
    );
  }
}
