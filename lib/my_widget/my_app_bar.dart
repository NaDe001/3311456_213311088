import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[300],
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        title: Text(
        "My Pet",
        style: TextStyle(fontSize: 30),
    ),
    ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
