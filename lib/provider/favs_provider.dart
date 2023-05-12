import 'package:flutter/cupertino.dart';
import 'package:shopping_app_flutter/models/cart_attr.dart';
import 'package:shopping_app_flutter/models/favs_attr.dart';

class FavsProvider with ChangeNotifier {
  Map<String, FavsAttr> _favsItems = {};

  Map<String, FavsAttr> get getFavsItems {
    return {..._favsItems};
  }

  void addAndRemoveFavs(
      String productId, double price, String title, String imageUrl) {
    if (_favsItems.containsKey(productId)) {
      removeItems(productId);
    } else {
      _favsItems.putIfAbsent(
          productId,
              () => FavsAttr(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              imageUrl: imageUrl));
    }
    notifyListeners();
  }


  void removeItems(String productId){
    _favsItems.remove(productId);
    notifyListeners();
  }

  void clearFavs(){
    _favsItems.clear();
    notifyListeners();
  }
}