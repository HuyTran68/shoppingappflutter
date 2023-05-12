import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/inner_creens/categories_feeds.dart';

class Category extends StatefulWidget {
  const Category({Key key, this.index}) : super(key: key);
  final int index;

  @override
  _CategoryState createState() => _CategoryState();
}
class _CategoryState extends State<Category>{
  List<Map<String, Object>> categories = [
    {
      'categoryName': 'Laptop',
      'categoryImagesPath': 'assets/images/category_1.jpg',
    },
    {
      'categoryName': 'Điện thoại',
      'categoryImagesPath': 'assets/images/category_2.jpg',
    },
    {
      'categoryName': 'Linh kiện',
      'categoryImagesPath': 'assets/images/category_3.jpg',
    },
    {
      'categoryName': 'Thời trang',
      'categoryImagesPath': 'assets/images/category_4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(CategoriesFeeds.routeName, arguments: '${categories[widget.index]['categoryName']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(categories[widget.index]['categoryImagesPath']), fit: BoxFit.fill),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 200,
            height: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Theme.of(context).backgroundColor,
            child: Text(
              categories[widget.index]['categoryName'],
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
