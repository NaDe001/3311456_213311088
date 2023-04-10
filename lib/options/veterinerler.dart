import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';

class Veterinerler extends StatelessWidget {
  const Veterinerler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[100],
      appBar: MyAppBar(),
      body: Center(
        child: Text(
          "En Yakın Veterinerlerin Listesi",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
