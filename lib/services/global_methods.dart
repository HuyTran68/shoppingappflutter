import 'package:flutter/material.dart';

class GlobalMethods{
  Future<void> showDialogg(String title, String subtitle, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://research.qut.edu.au/dmrc/wp-content/uploads/sites/5/2019/10/imgbin-warning-sign-scalable-graphics-alert-s-000a22VvEMW5D3pxSs8cuzq8Y.jpg',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy bỏ')),
              TextButton(
                  onPressed: () {
                    fct();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://research.qut.edu.au/dmrc/wp-content/uploads/sites/5/2019/10/imgbin-warning-sign-scalable-graphics-alert-s-000a22VvEMW5D3pxSs8cuzq8Y.jpg',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error'),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
}