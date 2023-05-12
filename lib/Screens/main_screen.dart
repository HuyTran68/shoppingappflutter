import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/Screens/bottom_bar.dart';
import 'package:shopping_app_flutter/Screens/upload_product_form.dart';

class Mainscreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        BottomBarScreen(),
        UploadProductForm(),
      ],
    );
  }
}
