import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purpleAccent[200],
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[400],
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
