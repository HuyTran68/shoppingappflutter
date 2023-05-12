import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:shopping_app_flutter/Screens/feeds.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shopping_app_flutter/inner_creens/brand_navigate_widget.dart';
import 'package:shopping_app_flutter/widgets/backplayer.dart';
import 'package:shopping_app_flutter/widgets/category.dart';
import 'package:shopping_app_flutter/widgets/popular_products.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_flutter/provider/products_provider.dart';

class Home extends StatefulWidget {
  static const routeName = '/Home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _carouselImages = [
    'assets/images/carousel_1.jpg',
    'assets/images/carousel_2.jpg',
    'assets/images/carousel_3.jpg',
  ];
  List _brandImages = [
    'assets/images/brandimages_1.jpg',
    'assets/images/brandimages_2.jpg',
    'assets/images/brandimages_3.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    productData.FetchProducts();
    final popularItem = productData.popularProducts;
    return Scaffold(
      body: Center(
        child: BackdropScaffold(
          frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          headerHeight: MediaQuery.of(context).size.height * 0.25,
          appBar: BackdropAppBar(
            title: Text("Trang chủ"),
            leading: BackdropToggleButton(
              icon: AnimatedIcons.home_menu,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                ColorsConsts.gradiendLStart,
                ColorsConsts.gradiendLEnd
              ])),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: AssetImage(
                        'assets/images/avatar_1.jpg'),
                  ),
                ),
                padding: const EdgeInsets.all(10),
              )
            ],
          ),
          backLayer: BackPlayer(),
          frontLayer: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: 190.0,
                    width: double.infinity,
                    child: Carousel(
                      images: [
                        ExactAssetImage(_carouselImages[0]),
                        ExactAssetImage(_carouselImages[1]),
                        ExactAssetImage(_carouselImages[2]),
                      ],
                      animationCurve: Curves.fastOutSlowIn,
                      dotPosition: DotPosition.bottomCenter,
                      dotSize: 5.0,
                      dotSpacing: 15.0,
                      dotColor: Colors.blueAccent,
                      indicatorBgPadding: 5.0,
                      dotBgColor: Colors.black.withOpacity(0.2),
                      borderRadius: true,
                      moveIndicatorFromBottom: 180.0,
                      noRadiusForIndicator: true,
                      boxFit: BoxFit.fill,
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Category(
                        index: index,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Thương hiệu phổ biến',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              BrandNavigationRailScreen.routeName,
                              arguments: {
                                7,
                              },
                            );
                          },
                          child: Text(
                            'Tất cả...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.blue),
                          ))
                    ],
                  ),
                ),
                Container(
                  height: 210,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Swiper(
                    scale: 0.7,
                    viewportFraction: 0.75,
                    itemCount: _brandImages.length,
                    autoplay: true,
                    onTap: (index) {
                      Navigator.of(context).pushNamed(
                          BrandNavigationRailScreen.routeName,
                          arguments: [
                            index,
                          ]);
                    },
                    itemBuilder: (BuildContext ctx, int index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.blueGrey,
                          child: Image.asset(
                            _brandImages[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Sản phẩm bán chạy',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      Spacer(),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Feeds.routeName, arguments: 'popular');
                          },
                          child: Text(
                            'Tất cả...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.blue),
                          ))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 285,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularItem.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: popularItem[index],
                        child: PopularProducts(),
                      );
                    },
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
