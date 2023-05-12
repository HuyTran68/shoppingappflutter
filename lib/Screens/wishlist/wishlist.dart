import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/const/my_icons.dart';
import 'package:shopping_app_flutter/provider/favs_provider.dart';
import 'package:shopping_app_flutter/services/global_methods.dart';
import 'package:shopping_app_flutter/Screens/wishlist/wishlist_empty.dart';
import 'package:shopping_app_flutter/Screens/wishlist/wishlist_full.dart';
import 'package:provider/provider.dart';

class Wishlist extends StatelessWidget {
  static const routeName = '/Wishlist';

  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final favsProvider = Provider.of<FavsProvider>(context);
    return favsProvider.getFavsItems.isEmpty
        ? Scaffold(body: WishListEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Text('Sản phẩm yêu thích'),
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
                        'Xóa sản phẩm yêu thích!',
                        'Tất cả sản phẩm yêu thích sẽ bị xóa',
                            () => favsProvider.clearFavs(), context);
                  },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: ListView.builder(
                itemCount: favsProvider.getFavsItems.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ChangeNotifierProvider.value(
                      value: favsProvider.getFavsItems.values.toList()[index],
                      child: Wishlistfull(
                        productId: favsProvider.getFavsItems.keys.toList()[index],
                      ));
                }));
  }
}
