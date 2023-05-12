import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/const/my_icons.dart';
import 'package:shopping_app_flutter/provider/cart_provider.dart';
import 'package:shopping_app_flutter/services/global_methods.dart';
import 'package:shopping_app_flutter/Screens/cart/cart_empty.dart';
import 'package:shopping_app_flutter/Screens/cart/cart_full.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  static const routeName = '/CartScreen';
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final cartProvider = Provider.of<CartProvider>(context);
    Future<void> _showDialog(
        String title, String subtitle, Function fct) async {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Image.network(
                      'https://research.qut.edu.au/dmrc/wp-content/uploads/sites/5/2019/10/imgbin-warning-sign-scalable-graphics-alert-s-000a22VvEMW5D3pxSs8cuzq8Y.jpg',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title),
                  ),
                ],
              ),
              content: Text(subtitle),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Hủy bỏ')),
                TextButton(
                    onPressed: () {
                      fct();
                      Navigator.pop(context);
                    },
                    child: Text('OK')),
              ],
            );
          });
    }

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              title: Text('Giỏ hàng'),
              backgroundColor: Colors.blueAccent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.blue]
                    )
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Xóa tất cả sản phẩm!',
                        'Tất cả sản phẩm trong giỏ hàng sẽ bị xóa',
                        () => cartProvider.clearCart(), context);
                  },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItems.values.toList()[index],
                      child: CartFull(
                        productId:
                            cartProvider.getCartItems.keys.toList()[index],
                        // id:  cartProvider.getCartItems.values.toList()[index].id,
                        // productId: cartProvider.getCartItems.keys.toList()[index],
                        // price: cartProvider.getCartItems.values.toList()[index].price,
                        // title: cartProvider.getCartItems.values.toList()[index].title,
                        // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                        // quatity: cartProvider.getCartItems.values.toList()[index].quantity,
                      ),
                    );
                  }),
            ),
          );
  }

  Widget checkoutSection(BuildContext ctx, double subtotal) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(colors: [
                      ColorsConsts.gradiendLStart,
                      ColorsConsts.gradiendLEnd,
                    ], stops: [
                      0.0,
                      0.7
                    ]),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {},
                      splashColor: Theme.of(ctx).splashColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Mua ngay',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(ctx).textSelectionColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Tổng cộng:',
                style: TextStyle(
                    color: Theme.of(ctx).textSelectionColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'US ${subtotal.toStringAsFixed(2)}',
                //textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
