import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/models/products.dart';
import 'package:shopping_app_flutter/provider/products_provider.dart';
import 'package:shopping_app_flutter/widgets/feed_products.dart';
import 'package:provider/provider.dart';

class CategoriesFeeds extends StatelessWidget {
  static const routeName = '/CategoriesFeeds';
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context).settings.arguments as String;
    print(categoryName);
    final productList = productsProvider.findByCategory(categoryName);
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách sản phẩm'),
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
          childAspectRatio: 250/450,
          children: List.generate(productList.length, (index){
            return ChangeNotifierProvider.value(
              value: productList[index],
              child: FeedProducts(
              ),
            );
          }),
        )
    );
  }
}