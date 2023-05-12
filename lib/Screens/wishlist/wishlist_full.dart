import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:shopping_app_flutter/models/favs_attr.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_flutter/provider/favs_provider.dart';
import 'package:shopping_app_flutter/services/global_methods.dart';

class Wishlistfull extends StatefulWidget {
  final String productId;

  const Wishlistfull({this.productId});
  @override
  _WishlistfullState createState() => _WishlistfullState();
}

class _WishlistfullState extends State<Wishlistfull> {
  @override
  Widget build(BuildContext context) {
    final favsAttr = Provider.of<FavsAttr>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      child: Image.network(favsAttr.imageUrl),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            favsAttr.title,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            '\$ ${favsAttr.price}',
                            style: const TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        positionedRemove(widget.productId),
      ],
    );
  }

  Widget positionedRemove(String productId) {
    final favsProvider = Provider.of<FavsProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();
    return Positioned(
        top: 20.0,
        right: 15.0,
        child: SizedBox(
          height: 30.0,
          width: 30.0,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(0.0),
            color: ColorsConsts.favColor,
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => {
              globalMethods.showDialogg(
                  'Xóa sản phẩm yêu thích!',
                  'Sản phẩm yêu thích này sẽ bị xóa',
                  () => favsProvider.removeItems(productId),
                  context),
            },
          ),
        ));
  }
}
