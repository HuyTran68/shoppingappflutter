import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app_flutter/const/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/global_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _productTitle = '';
  var _productPrice = '';
  var _productCategory = '';
  var _productBrand = '';
  var _productDescription = '';
  var _productQuantity = '';
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  String _categoryValue;
  String _brandValue;
  GlobalMethods _globalMethods = GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File _pickedImage;
  bool _isLoading = false;
  String url;
  var uuid = Uuid();
  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      print(_productTitle);
      print(_productPrice);
      print(_productCategory);
      print(_productBrand);
      print(_productDescription);
      print(_productQuantity);
      // Use those values to send our request ...
    }
    if (isValid) {
      _formKey.currentState.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Bạn chưa chọn hình ảnh sản phẩm!', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('products_Images')
              .child(_productTitle + '.jpg');
          await ref.putFile(_pickedImage);
          url = await ref.getDownloadURL();

          final User user = _auth.currentUser;
          final _uid = user.uid;
          final productId = uuid.v4();
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .set({
            'productId': productId,
            'productTitle': _productTitle,
            'price': _productPrice,
            'productImage': url,
            'productCategory': _productCategory,
            'productBrand': _productBrand,
            'productDescription': _productDescription,
            'productQuantity': _productQuantity,
            'userId': _uid,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
        print('error occured ${error.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConsts.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: _trySubmit,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Center(
                      child: Container(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()))
                      : Text('Tải lên',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
                GradientIcon(
                  Feather.upload,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow[800]
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: ValueKey('Title'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Xin nhập tên sản phẩm!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Tên sản phẩm',
                                  ),
                                  onSaved: (value) {
                                    _productTitle = value;
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                key: ValueKey('Price \$'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Giá sản phẩm trống!';
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Giá \$',
                                  //  prefixIcon: Icon(Icons.mail),
                                  // suffixIcon: Text(
                                  //   '\n \n \$',
                                  //   textAlign: TextAlign.start,
                                  // ),
                                ),
                                //obscureText: true,
                                onSaved: (value) {
                                  _productPrice = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        /* Image picker here ***********************************/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //  flex: 2,
                              child: this._pickedImage == null
                                  ? Container(
                                margin: EdgeInsets.all(10),
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                  Theme.of(context).backgroundColor,
                                ),
                              )
                                  : Container(
                                margin: EdgeInsets.all(10),
                                height: 200,
                                width: 200,
                                child: Container(
                                  height: 200,
                                  // width: 200,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.only(
                                    //   topLeft: const Radius.circular(40.0),
                                    // ),
                                    color:
                                    Theme.of(context).backgroundColor,
                                  ),
                                  child: Image.file(
                                    this._pickedImage,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: FlatButton.icon(
                                    textColor: Colors.white,
                                    onPressed: _pickImageCamera,
                                    icon: Icon(Icons.camera,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: FlatButton.icon(
                                    textColor: Colors.white,
                                    onPressed: _pickImageGallery,
                                    icon: Icon(Icons.image,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Thư viện',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: FlatButton.icon(
                                    textColor: Colors.white,
                                    onPressed: _removeImage,
                                    icon: Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      'Xóa ảnh',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        //    SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _categoryController,

                                    key: ValueKey('Category'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Xin nhập loại sản phẩm!';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Thêm loại sản phẩm',
                                    ),
                                    onSaved: (value) {
                                      _productCategory = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Laptop'),
                                  value: 'Laptop',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Điện thoại'),
                                  value: 'Điện thoại',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Linh kiện'),
                                  value: 'Linh kiện',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Thời trang'),
                                  value: 'Thời trang',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  _categoryValue = value;
                                  _categoryController.text = value;
                                  //_controller.text= _productCategory;
                                  print(_productCategory);
                                });
                              },
                              hint: Text('Chọn loại sản phẩm'),
                              value: _categoryValue,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _brandController,

                                    key: ValueKey('Brand'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Nhãn hiệu bị trống!';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Nhãn hiệu',
                                    ),
                                    onSaved: (value) {
                                      _productBrand = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Apple'),
                                  value: 'Apple',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Gucci'),
                                  value: 'Gucci',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Versace'),
                                  value: 'Versace',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Dell'),
                                  value: 'Dell',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Nvidia'),
                                  value: 'Nvidia',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Asus'),
                                  value: 'Asus',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Intel'),
                                  value: 'Intel',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  _brandValue = value;
                                  _brandController.text = value;
                                  print(_productBrand);
                                });
                              },
                              hint: Text('Chọn nhãn hiệu'),
                              value: _brandValue,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                            key: ValueKey('Description'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mô tả sản phẩm bị trống!';
                              }
                              return null;
                            },
                            //controller: this._controller,
                            maxLines: 10,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              //  counterText: charLength.toString(),
                              labelText: 'Mô tả',
                              hintText: 'Mô tả sản phẩm',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _productDescription = value;
                            },
                            onChanged: (text) {
                              // setState(() => charLength -= text.length);
                            }),
                        //    SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              //flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  key: ValueKey('Quantity'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Số lượng bị trống!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Số lượng',
                                  ),
                                  onSaved: (value) {
                                    _productQuantity = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
      this.icon,
      this.size,
      this.gradient,
      );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}