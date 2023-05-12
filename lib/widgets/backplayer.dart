import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/Screens/cart/cart.dart';
import 'package:shopping_app_flutter/Screens/feeds.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:shopping_app_flutter/const/my_icons.dart';
import 'package:shopping_app_flutter/Screens/upload_product_form.dart';

class BackPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorsConsts.gradiendLStart,
                ColorsConsts.gradiendLEnd,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        Positioned(
          top: -100,
          left: 140.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150.0,
              height: 250.0,
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 100.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150.0,
              height: 300.0,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/avatar_1.jpg'),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                content(context, () {
                  NavigateTo(context, Feeds.routeName);
                }, 'Danh sách sản phẩm', 0),
                const SizedBox(
                  height: 10.0,
                ),
                content(context, () {
                  NavigateTo(context, Cart.routeName);
                }, 'Thanh toán', 1),
                const SizedBox(
                  height: 10.0,
                ),
                content(context, () {
                  NavigateTo(context, Feeds.routeName);
                }, 'Danh sách yêu thích', 2),
                const SizedBox(
                  height: 10.0,
                ),
                content(context, () {
                  NavigateTo(context, UploadProductForm.routeName);
                }, 'Upload sản phẩm mới', 3),
              ],
            ),
          ),
        )
      ],
    );
  }

  final List _contentIcons = [
    MyAppIcons.rss,
    MyAppIcons.cart,
    MyAppIcons.wishlist,
    MyAppIcons.upload,
  ];
  void NavigateTo(BuildContext ctx, String routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  Widget content(BuildContext ctx, Function fct, String text, int index) {
    return InkWell(
      onTap: fct,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Icon(_contentIcons[index]),
        ],
      ),
    );
  }
}
