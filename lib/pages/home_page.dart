import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/pages/profil_page.dart';
import 'package:follow_pet/pages/ayarlar_page.dart';

import 'anasayfa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final selectedColor = Colors.white;
  final unselectedColor = Colors.white60;
  final labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    Widget _getPage(int index) {
      switch (index) {
        case 0:
          return Anasayfa();
        case 1:
          return ProfilePage();
        case 2:
          return Ayarlar();
        default:
          return Anasayfa(); // Varsayılan sayfa
      }
    }

    return Scaffold(
      backgroundColor: Colors.purpleAccent[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[400],
        title: Text(
          "My Pet",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.purple[400],
            selectedLabelTextStyle: labelStyle.copyWith(color: selectedColor),
            unselectedLabelTextStyle:
                labelStyle.copyWith(color: unselectedColor),
            selectedIconTheme: IconThemeData(color: Colors.white, size: 50),
            unselectedIconTheme: IconThemeData(color: Colors.white, size: 50),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_circle),
                label: Text("Profil"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text("Ayarlar"),
              ),
            ],
          ),
          Expanded(
            child: _getPage(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
