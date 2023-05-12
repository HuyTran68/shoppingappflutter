import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:shopping_app_flutter/Screens/cart/cart.dart';
import 'package:shopping_app_flutter/Screens/wishlist/wishlist.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_flutter/const/my_icons.dart';
import 'package:shopping_app_flutter/provider/dark_theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserInfo extends StatefulWidget {
  @override
  _Userinfostate createState() => _Userinfostate();
}

class _Userinfostate extends State<UserInfo> {
  ScrollController _scrollcontroller;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  String _name;
  String _email;
  String _joinedAt;
  int _phoneNumber;
  String _userImagesUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollcontroller = ScrollController();
    _scrollcontroller.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User user = _auth.currentUser;
    _uid = user.uid;
    print('displayName ${user.displayName}');
    print('photourl ${user.photoURL}');
    print('imagesurl${_userImagesUrl}');
    final DocumentSnapshot userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _name = userDoc.get('name');
        _email = user.email;
        _joinedAt = userDoc.get('joinedDay');
        _phoneNumber = userDoc.get('phoneNumber');
        _userImagesUrl = userDoc.get('imageUrl');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          controller: _scrollcontroller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 4,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints contraints) {
                top = contraints.biggest.height;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          ColorsConsts.starterColor,
                          ColorsConsts.endColor,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: top <= 110.0 ? 1.0 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              Container(
                                height: kToolbarHeight / 1.8,
                                width: kToolbarHeight / 1.8,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(_userImagesUrl ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1oIN6GTaH0tkB0iRknESvgKQtfwkAEyQOLw&usqp=CAU'),
                                    )),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Text(_name == null ? 'Khách hàng' : _name,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white))
                            ],
                          ),
                        )
                      ],
                    ),
                    background: Image(
                      image: NetworkImage(_userImagesUrl ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1oIN6GTaH0tkB0iRknESvgKQtfwkAEyQOLw&usqp=CAU'),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Tittles('Sưu tầm')),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () =>
                            Navigator.of(context).pushNamed(Wishlist.routeName),
                        title: Text('Yêu Thích'),
                        trailing: Icon(Icons.chevron_right_rounded),
                        leading: Icon(MyAppIcons.wishlist),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () =>
                            Navigator.of(context).pushNamed(Cart.routeName),
                        title: Text('Giỏ Hàng'),
                        trailing: Icon(Icons.chevron_right_rounded),
                        leading: Icon(MyAppIcons.cart),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () =>
                            Navigator.of(context).pushNamed(Wishlist.routeName),
                        title: Text('Yêu Thích'),
                        trailing: Icon(Icons.chevron_right_rounded),
                        leading: Icon(Entypo.shopping_bag),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Tittles('Thông tin khách hàng')),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  userListtitle('Email', _email ?? '', Icons.email, context),
                  userListtitle('Số Điện Thoại', _phoneNumber.toString() ?? '',
                      Icons.phone, context),
                  userListtitle('Địa Chỉ', '', Icons.house, context),
                  userListtitle(
                      'Ngày Gia Nhập', _joinedAt ?? '', Icons.timer, context),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Tittles('Cài Đặt')),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  ListTileSwitch(
                    value: themeChange.darkTheme,
                    leading: Icon(Icons.sunny),
                    onChanged: (value) {
                      setState(() {
                        themeChange.darkTheme = value;
                      });
                    },
                    visualDensity: VisualDensity.comfortable,
                    switchType: SwitchType.cupertino,
                    switchActiveColor: Colors.indigo,
                    title: Text('Dark Mode'),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () async {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Image.network(
                                          'https://www.kindpng.com/picc/m/19-194798_transparent-logout-png-sign-out-icon-transparent-png.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Thoát tài khoản'),
                                      ),
                                    ],
                                  ),
                                  content: Text('Bạn có muốn thoát!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Hủy bỏ')),
                                    TextButton(
                                        onPressed: () async {
                                          await _auth.signOut().then((value) =>
                                              Navigator.pop(context));
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ],
                                );
                              });
                        },
                        title: Text('Đăng xuất'),
                        leading: Icon(Icons.exit_to_app_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        buildFab()
      ]),
    );
  }

  Widget Tittles(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildFab() {
    final double defaulTopmagin = 200.0 - 4.0;
    final double scaleStart = 160.0;
    final double scaleEnd = scaleStart / 2;

    double top = defaulTopmagin;
    double scale = 1.0;
    if (_scrollcontroller.hasClients) {
      double offset = _scrollcontroller.offset;
      top -= offset;
      if (offset < defaulTopmagin - scaleStart) {
        scale = 1.0;
      } else if (offset < defaulTopmagin - scaleEnd) {
        scale = (defaulTopmagin - scaleEnd - offset) / scaleEnd;
      } else {
        scale = 0.0;
      }
    }
    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          heroTag: "",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  Widget userListtitle(
      String title, String subTitle, IconData icon, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(
          onTap: () async {},
          title: Text(title),
          subtitle: Text(subTitle),
          leading: Icon(icon),
          trailing: Icon(Icons.check),
        ),
      ),
    );
  }
}
