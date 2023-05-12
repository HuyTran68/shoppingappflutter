import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:shopping_app_flutter/inner_creens/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_flutter/models/products.dart';
import 'package:shopping_app_flutter/widgets/feed_dialog.dart';

class FeedProducts extends StatefulWidget {
  @override
  _FeedProductsState createState() => _FeedProductsState();
}

class _FeedProductsState extends State<FeedProducts> {
  @override
  Widget build(BuildContext context) {
    final productsAttribute = Provider.of<Product>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, ProductDetail.routeName,
            arguments: productsAttribute.id),
        child: Container(
          width: 250,
          height: 340,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.network(
                        productsAttribute.imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Badge(
                    toAnimate: false,
                    shape: BadgeShape.square,
                    badgeColor: Colors.blue,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8)),
                    badgeContent: const Text('New',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                margin: const EdgeInsets.only(left: 5, bottom: 2, right: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      productsAttribute.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '\$ ${productsAttribute.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${productsAttribute.quantity}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => FeedDialog(
                                      productId: productsAttribute.id));
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
