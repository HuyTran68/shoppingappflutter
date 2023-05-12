import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/Screens/feeds.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:shopping_app_flutter/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class OrderEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 80),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/empty_cart.jpg'),
            ),
          ),
        ),
        Text(
          'Giỏ hàng đang trống',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 36,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Có vẻ như chưa có \n sản phẩm trong giỏ hàng',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: themeChange.darkTheme
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          child: RaisedButton(
            onPressed: () {Navigator.of(context).pushNamed(Feeds.routeName);},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.red),
            ),
            color: Colors.redAccent,
            child: Text(
              'Shop now'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}