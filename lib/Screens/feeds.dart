import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/Screens/wishlist/wishlist.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:shopping_app_flutter/const/my_icons.dart';
import 'package:shopping_app_flutter/models/products.dart';
import 'package:shopping_app_flutter/provider/cart_provider.dart';
import 'package:shopping_app_flutter/provider/favs_provider.dart';
import 'package:shopping_app_flutter/provider/products_provider.dart';
import 'package:shopping_app_flutter/widgets/feed_products.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import 'cart/cart.dart';

class Feeds extends StatelessWidget {
  static const routeName = '/Feeds';
  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context).settings.arguments as String;
    final productsProvider = Provider.of<Products>(context);
    List<Product> productList = productsProvider.products;
    if (popular == 'popular') {
      productList = productsProvider.popularProducts;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('danh sách sản phẩm'),
          backgroundColor: Colors.blueAccent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.blue]
              )
            ),
          ),
          actions: [
            Consumer<FavsProvider>(
              builder: (_, favs, ch) => Badge(
                badgeColor: ColorsConsts.cartBadgeColor,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                position: BadgePosition.topEnd(top: 5, end: 7),
                badgeContent: Text(
                  favs.getFavsItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(
                    MyAppIcons.wishlist,
                    color: ColorsConsts.favColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Wishlist.routeName);
                  },
                ),
              ),
            ),
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                badgeColor: ColorsConsts.cartBadgeColor,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                position: BadgePosition.topEnd(top: 5, end: 7),
                badgeContent: Text(
                  cart.getCartItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(
                    MyAppIcons.cart,
                    color: ColorsConsts.cartColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Cart.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
        // body: StaggeredGridView.countBuilder(
        //   crossAxisCount: 6,
        //   itemCount: 8,
        //   itemBuilder: (BuildContext context, int index) => FeedProducts(),
        //   staggeredTileBuilder: (int index) => new StaggeredTile.count(3, index.isEven ? 4.5 : 5),
        //   mainAxisSpacing: 8,
        //   crossAxisSpacing: 6,
        // )
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 250 / 450,
          children: List.generate(productList.length, (index) {
            return ChangeNotifierProvider.value(
              value: productList[index],
              child: FeedProducts(),
            );
          }),
        ));
  }
}
