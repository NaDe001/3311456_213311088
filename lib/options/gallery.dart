import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';


class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.purpleAccent[100],
     appBar: MyAppBar(),
    body: Container(
      child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 1.5,
          mainAxisSpacing: 50,
          children: <Widget>[
            Image.asset('resim/foto5.png'),
            Image.asset('resim/foto6.png'),
            Image.asset('resim/foto3.png'),
            Image.asset('resim/foto4.png'),
            Image.asset('resim/foto7.png'),
          ],
        ),
    ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add,size: 40,),
          Text('Yeni Fotoğraf Ekle'),
        ],
      ),
    );
  }
}
