import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shopping_app_flutter/inner_creens/product_detail.dart';
import 'package:shopping_app_flutter/models/products.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_flutter/provider/cart_provider.dart';
import 'package:shopping_app_flutter/provider/favs_provider.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsAttribute = Provider.of<Product>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(
              10.0,
            ),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(
                10.0,
              ),
              bottomRight: Radius.circular(10.0),
            ),
            onTap: () => Navigator.pushNamed(context, ProductDetail.routeName,
                arguments: productsAttribute.id),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(productsAttribute.imageUrl),
                              fit: BoxFit.contain)),
                    ),
                    Positioned(
                      right: 10,
                      top: 8,
                      child: Icon(
                        Entypo.star,
                        color: favsProvider.getFavsItems
                                .containsKey(productsAttribute.id)
                            ? Colors.blueAccent
                            : Colors.grey.shade800,
                      ),
                    ),
                    const Positioned(
                      right: 10,
                      top: 8,
                      child: Icon(
                        Entypo.star_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 32.0,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Theme.of(context).backgroundColor,
                        child: Text(
                          '\$ ${productsAttribute.price}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productsAttribute.title,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              productsAttribute.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 1,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: cartProvider.getCartItems
                                        .containsKey(productsAttribute.id)
                                    ? () {}
                                    : () {
                                        cartProvider.addProductToCart(
                                            productsAttribute.id,
                                            productsAttribute.price,
                                            productsAttribute.title,
                                            productsAttribute.imageUrl);
                                      },
                                borderRadius: BorderRadius.circular(30.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    cartProvider.getCartItems
                                            .containsKey(productsAttribute.id)
                                        ? MaterialCommunityIcons.check_all
                                        : MaterialCommunityIcons.cart_plus,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
