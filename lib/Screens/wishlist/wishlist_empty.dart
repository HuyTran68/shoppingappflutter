import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/Screens/feeds.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:shopping_app_flutter/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class WishListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/wishlist_empty.jpg'))),
        ),
        const SizedBox(
          height: 60,
        ),
        Text(
          'Danh sách yêu thích Đang Trống',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Có vẻ như bạn chưa \n thêm sản phẩm yêu thích',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeChange.darkTheme
                ? Theme.of(context).disabledColor
                : ColorsConsts.subTitle,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 120,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.4,
          height: MediaQuery.of(context).size.height * 0.09,
          child: ElevatedButton(
              onPressed: () =>
                  {Navigator.of(context).pushNamed(Feeds.routeName)},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.greenAccent),
                    ),
                  )),
              child: Text(
                'Thêm sản phẩm yêu thích'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ),
      ],
    );
  }
}
