import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:shopping_app_flutter/services/global_methods.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Signup extends StatefulWidget {
  static const routeName = '\Signup';
  @override
  _Signup createState() => _Signup();
}

class _Signup extends State<Signup> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  String _fullName = '';
  String url;
  int _phoneNumber;
  File _pickImage;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var fomattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    if (isValid) {
      _formKey.currentState.save();
      try {
        if (_pickImage == null) {
          _globalMethods.authErrorHandle('Bạn chưa chọn hình ảnh!', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(_fullName + '.jpg');
          await ref.putFile(_pickImage);
          url = await ref.getDownloadURL();
          await _auth.createUserWithEmailAndPassword(
              email: _emailAddress.toLowerCase().trim(),
              password: _password.trim());
          final User user = _auth.currentUser;
          final _uid = user.uid;
          user.updateDisplayName(_fullName);
          user.updatePhotoURL(url);
          user.reload();
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullName,
            'email': _emailAddress,
            'phoneNumber': _phoneNumber,
            'imageUrl': url,
            'joinedDay': fomattedDate,
            'createdDay': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
        print('Error occured ${error.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickerImage = await picker.pickImage(source: ImageSource.camera);
    final pickImageFile = File(pickerImage.path);
    setState(() {
      _pickImage = pickImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallary() async {
    final picker = ImagePicker();
    final pickerImage = await picker.pickImage(source: ImageSource.gallery);
    final pickImageFile = File(pickerImage.path);
    setState(() {
      _pickImage = pickImageFile;
    });
    Navigator.pop(context);
  }

  void _removeImage() {
    setState(() {
      _pickImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.deepPurple, Colors.pinkAccent],
                    [Colors.deepPurple, Colors.blue],
                  ],
                  durations: [
                    19440,
                    10800,
                  ],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: ColorsConsts.gradiendLEnd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              _pickImage == null ? null : FileImage(_pickImage),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 110,
                      child: RawMaterialButton(
                        elevation: 10,
                        fillColor: ColorsConsts.gradiendLEnd,
                        child: Icon(Icons.add_a_photo),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Lựa chọn',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsConsts.gradiendLStart),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        InkWell(
                                          onTap: _pickImageCamera,
                                          splashColor: Colors.blueAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                              Text(
                                                'Máy ảnh',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: ColorsConsts.title,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _pickImageGallary,
                                          splashColor: Colors.blueAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                              Text(
                                                'Thư viện',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: ColorsConsts.title,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _removeImage,
                                          splashColor: Colors.pinkAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(
                                                'Xóa ảnh',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('ten'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tên không được bỏ trống!';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(Feather.user),
                              labelText: 'Họ và tên',
                              fillColor: Theme.of(context).backgroundColor),
                          onSaved: (value) {
                            _fullName = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('email'),
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Xin nhập email của bạn';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              fillColor: Theme.of(context).backgroundColor),
                          onSaved: (value) {
                            _emailAddress = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('pass'),
                          validator: (value) {
                            if (value.isEmpty || value.length <= 6) {
                              return 'Xin nhập mật khẩu của bạn';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Mật khẩu',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              fillColor: Theme.of(context).backgroundColor),
                          onSaved: (value) {
                            _password = value;
                          },
                          obscureText: _obscureText,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNumberFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('phone number'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Xin nhập SDT của bạn';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          focusNode: _phoneNumberFocusNode,
                          onEditingComplete: _submitForm,
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(Icons.phone_iphone),
                              labelText: 'Số điện thoại',
                              fillColor: Theme.of(context).backgroundColor),
                          onSaved: (value) {
                            _phoneNumber = int.parse(value);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              side: BorderSide(
                                                  color: ColorsConsts
                                                      .backgroundColor)))),
                                  onPressed: _submitForm,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Đăng ký',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17)),
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
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
