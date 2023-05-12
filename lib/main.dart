import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/Screens/auth/forgot_password.dart';
import 'package:shopping_app_flutter/Screens/auth/sign_up.dart';
import 'package:shopping_app_flutter/Screens/bottom_bar.dart';
import 'package:shopping_app_flutter/Screens/cart/cart.dart';
import 'package:shopping_app_flutter/Screens/user_state.dart';
import 'package:shopping_app_flutter/Screens/wishlist/wishlist.dart';
import 'package:shopping_app_flutter/const/theme_data.dart';
import 'package:shopping_app_flutter/inner_creens/brand_navigate_widget.dart';
import 'package:shopping_app_flutter/inner_creens/categories_feeds.dart';
import 'package:shopping_app_flutter/Screens/upload_product_form.dart';
import 'package:shopping_app_flutter/provider/cart_provider.dart';
import 'package:shopping_app_flutter/provider/dark_theme_provider.dart';
import 'package:shopping_app_flutter/provider/favs_provider.dart';
import 'package:shopping_app_flutter/provider/products_provider.dart';
import 'package:provider/provider.dart';
import 'Screens/auth/login.dart';
import 'Screens/cart/cart.dart';
import 'Screens/feeds.dart';
import 'Screens/home.dart';
import 'inner_creens/product_detail.dart';
import 'package:firebase_core/firebase_core.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider ThemeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    ThemeChangeProvider.darkTheme =
        await ThemeChangeProvider.darkThemePre.getTheme();
  }
  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              return ThemeChangeProvider;
            }),
            ChangeNotifierProvider(create: (_) =>
              Products(),
            ),
            ChangeNotifierProvider(create: (_) =>
              CartProvider(),
            ),
            ChangeNotifierProvider(create: (_) =>
              FavsProvider(),
            ),
          ],
          child: Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(ThemeChangeProvider.darkTheme, context),
              home: UserState(),
              routes: {
                //   '/': (ctx) => LandingPage(),
                BrandNavigationRailScreen.routeName: (ctx) =>
                    BrandNavigationRailScreen(),
                Feeds.routeName: (ctx) => Feeds(),
                Cart.routeName: (ctx) => Cart(),
                Wishlist.routeName: (ctx) => Wishlist(),
                ProductDetail.routeName: (ctx) => ProductDetail(),
                CategoriesFeeds.routeName: (ctx) => CategoriesFeeds(),
                Home.routeName: (ctx) => Home(),
                Login.routeName: (ctx) => Login(),
                Signup.routeName: (ctx) => Signup(),
                BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                UploadProductForm.routeName: (ctx) => UploadProductForm(),
                ForgetPassword.routeName: (ctx) => ForgetPassword(),
              }
            );
          }),
        );
      }
    );
  }
}
