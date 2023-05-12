import 'package:flutter/cupertino.dart';
import 'package:shopping_app_flutter/models/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products {
    return [..._products];
  }

  Future<void> FetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productsSnapshot) {
          _products = [];
          productsSnapshot.docs.forEach((element) {
            _products.insert(0, Product(
                id: element.get('productId'),
                title: element.get('productTitle'),
                description: element.get('productDescription'),
                price: double.parse(element.get('price')),
                imageUrl: element.get('productImage'),
                brand: element.get('productBrand'),
                productCategoryName: element.get('productCategory'),
                quantity: int.parse(element.get('productQuantity')),
                isPopular: true
            ));
          });
    });
  }

  List<Product> get popularProducts {
    return _products.where((element) => element.isPopular).toList();
  }

  Product findById(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String categoryName) {
    List _categoryList = _products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<Product> findByBrand(String brandName) {
    List _categoryList = _products
        .where((element) =>
            element.brand.toLowerCase().contains(brandName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<Product> searchQuery(String searchText) {
    List _searchList = _products
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }

  /*List<Product> _products = [
    Product(
        id: 'guccisneaker1',
        title: 'Gucci Bee Sneaker',
        description: 'Gucci Bee Sneaker',
        price: 300.0,
        imageUrl: 'assets/images/gucci-bee-sneaker.jpg',
        brand: 'Gucci',
        productCategoryName: 'Thời trang',
        quantity: 65,
        isPopular: true),
    Product(
        id: 'guccibag1',
        title: 'Gucci Bag',
        description: 'Gucci Bag',
        price: 150.0,
        imageUrl: 'assets/images/gucci-bag.jpg',
        brand: 'Gucci ',
        productCategoryName: 'Thời trang',
        quantity: 300,
        isPopular: false),
    Product(
        id: 'gucciclock1',
        title: 'Gucci Clock',
        description: 'Gucci Clock',
        price: 500,
        imageUrl: 'assets/images/gucci-clock.jpg',
        brand: 'Gucci',
        productCategoryName: 'Thời trang',
        quantity: 6423,
        isPopular: true),
    Product(
        id: 'guccichat1',
        title: 'Gucci hat',
        description: 'Gucci hat',
        price: 500,
        imageUrl: 'assets/images/gucci-hat.jpg',
        brand: 'Gucci',
        productCategoryName: 'Thời trang',
        quantity: 6423,
        isPopular: true),
    Product(
        id: 'ggpixel4',
        title: 'Google Pixel 4',
        description: 'GG pixel 4 64GB ROM 6GB RAM Snapdragon 855',
        price: 600,
        imageUrl: 'assets/images/ggpixel-4.jpg',
        brand: 'Google',
        productCategoryName: 'Điện thoại',
        quantity: 30,
        isPopular: false),
    Product(
        id: 'ggpixel5',
        title: 'Google Pixel 5',
        description: 'GG pixel 5 64GB ROM 6GB RAM Snapdragon 855',
        price: 800,
        imageUrl: 'assets/images/ggpixel-5.jpg',
        brand: 'Google',
        productCategoryName: 'Điện thoại',
        quantity: 10,
        isPopular: false),
    Product(
        id: 'ggpixel6',
        title: 'Google Pixel 6',
        description: 'GG pixel 6 64GB ROM 6GB RAM Snapdragon 855',
        price: 900,
        imageUrl: 'assets/images/ggpixel-6.jpg',
        brand: 'Google',
        productCategoryName: 'Điện thoại',
        quantity: 5,
        isPopular: true),
    Product(
        id: 'ip12',
        title: 'Iphone 12 64GB',
        description: 'Iphone 12 64GB 4GB RAM Chip Apple A13',
        price: 1200,
        imageUrl: 'assets/images/ip12.jpg',
        brand: 'Apple',
        productCategoryName: 'Điện thoại',
        quantity: 20,
        isPopular: true),
    Product(
        id: 'sss22ultra',
        title: 'Samsung S22 Ultra',
        description: 'Samsung S22 Ultra 64GB 4GB RAM Chip Exinos 9400',
        price: 1200,
        imageUrl: 'assets/images/sss22ultra.jpg',
        brand: 'Samsung',
        productCategoryName: 'Điện thoại',
        quantity: 5,
        isPopular: true),

  ];
  */
}
