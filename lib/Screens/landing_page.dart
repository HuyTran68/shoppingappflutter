import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app_flutter/Screens/auth/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shopping_app_flutter/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  List<String> images = [
    'https://thumbs.dreamstime.com/b/supermarket-cart-loaded-cardboard-boxes-sales-goods-concept-trade-commerce-online-shopping-high-delivery-order-134531493.jpg',
    'https://englishperiod.com/wp-content/uploads/2020/10/Shopping-Malls-in-Indore_600x400-1280x720-1.jpg',
    'https://www.addictioncenter.com/app/uploads/2020/01/online_shopping_addiction-scaled.jpeg',
    'https://www.wordstream.com/wp-content/uploads/2021/07/google-shopping-feed-ecommerce-final.jpg',
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _googleSignin() async {
    final googleSignin = GoogleSignIn();
    final googleAccount = await googleSignin.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateparse = DateTime.parse(date);
          var fomattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken));
          await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
            'id': authResult.user.uid,
            'name': authResult.user.displayName,
            'email': authResult.user.email,
            'phoneNumber': authResult.user.phoneNumber,
            'imageUrl': authResult.user.photoURL,
            'joinedDay': fomattedDate,
            'createdDay': Timestamp.now(),
          });
        } catch (error) {
          _globalMethods.authErrorHandle(error.message, context);
        }
      }
    }
  }

  void _loginAnonmously() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.signInAnonymously();
    } catch (error) {
      _globalMethods.authErrorHandle(error.message, context);
      print('Error occured ${error.message}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: images[1],
            // placeholder: (context, url) => Image.network(
            //   'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/r/s/rsz_l19a_mech_bigsal_vietnam_domteaser_1sheet.jpg',
            //   fit: BoxFit.fill,
            // ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Chào mừng',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 40,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Text(
                    'Chào mừng đến với cửa hàng chúng tôi!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                          color:
                                              ColorsConsts.backgroundColor)))),
                      onPressed: () {
                        Navigator.pushNamed(context, Login.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Đăng nhập',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Feather.user,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink.shade400),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                        color: ColorsConsts.backgroundColor)))),
                        onPressed: () {
                          Navigator.pushNamed(context, Signup.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Đăng ký',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17)),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Feather.user_plus,
                              size: 18,
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ),
                  Text(
                    'Hoặc đăng nhập với',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: _googleSignin,
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(width: 2, color: Colors.red),
                    ),
                    child: Text(
                      'Google +',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : OutlinedButton(
                          onPressed: () {
                            _loginAnonmously();
                            //Navigator.pushNamed(context, BottomBarScreen.routeName);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(width: 2, color: Colors.red),
                          ),
                          child: Text(
                            'Đăng nhập với tài khoản khách',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 40,
              )
            ],
          )
        ],
      ),
    );
  }
}
