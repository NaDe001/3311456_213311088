import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:follow_pet/options/asi_takvimi.dart';
import 'package:follow_pet/options/dis_parazit.dart';
import 'package:follow_pet/options/gallery.dart';
import 'package:follow_pet/options/ic_parazit.dart';
import 'package:follow_pet/options/tedaviler.dart';
import 'package:follow_pet/options/veterinerler.dart';

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.purpleAccent[200],
        body: SafeArea(
          child: Center(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[500],
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Asi(),
                        ),
                      );
                    },
                    child: Text('Aşı Takvimi'),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan,
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ic_Parazit(),
                        ),
                      );
                    },
                    child: Text('İç Parazit'),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent[200],
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dis_Parazit(),
                        ),
                      );
                    },
                    child: Text('Dış Parazit'),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[700],
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tedaviler(),
                        ),
                      );
                    },
                    child: Text('Tedaviler'),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink[500],
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Veterinerler(),
                        ),
                      );
                    },
                    child: Text('Veterinerler'),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[800],
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Gallery(),
                        ),
                      );
                    },
                    child: Text('Gallery'),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(height: 16),
      ),
    );
  }
}
