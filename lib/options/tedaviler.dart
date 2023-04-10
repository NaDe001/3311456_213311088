import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';

class Tedaviler extends StatelessWidget {
  const Tedaviler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[100],
      appBar: MyAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [ Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                width: 450,
                height: 400,
                color: Colors.white70,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Teşhis",style: TextStyle(fontSize: 30,color: Colors.red),),
                          SizedBox(height: 10,),
                          Text("Bacağında mantara saptanmıştır",style: TextStyle(fontSize: 25),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Tedavi",style: TextStyle(fontSize: 30, color: Colors.red),),
                          SizedBox(height: 10,),
                          Text("Mantar Aşısı yapılmıştır.",style: TextStyle(fontSize: 25),),
                          SizedBox(height: 10,),
                          Text("Mantar kremi kullanılmıltır",style: TextStyle(fontSize: 25),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                        children: [
                          Text("Veteriner", style: TextStyle(fontSize: 30,color: Colors.red),),
                          SizedBox(height: 10,),
                          Text("Giresun Pet",style: TextStyle(fontSize: 25),),
                        ],
                    )
                    ),
                    SizedBox(height: 15,),
                    Container(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Text("Tarih", style: TextStyle(fontSize: 30,color: Colors.red),),
                            SizedBox(height: 10,),
                            Text("15/04/2023",style: TextStyle(fontSize: 25),),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 450,
                height: 450,
                color: Colors.white70,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Teşhis",style: TextStyle(fontSize: 30,color: Colors.red),),
                          SizedBox(height: 10,),
                          Text("Karnında iltihaplanma vardır",style: TextStyle(fontSize: 25),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Tedavi",style: TextStyle(fontSize: 30, color: Colors.red),),
                          SizedBox(height: 10,),
                          Text("Ameliyatla rahmi alınmıştır.",style: TextStyle(fontSize: 25),),
                          SizedBox(height: 10,),
                          Text("Vitaminli mama kullanılmıştır.",style: TextStyle(fontSize: 25),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Text("Veteriner", style: TextStyle(fontSize: 30,color: Colors.red),),
                            SizedBox(height: 10,),
                            Text("Giresun Pet",style: TextStyle(fontSize: 25),),
                          ],
                        )
                    ),
                    SizedBox(height: 15,),
                    Container(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Text("Tarih", style: TextStyle(fontSize: 30,color: Colors.red),),
                            SizedBox(height: 10,),
                            Text("02/06/2017",style: TextStyle(fontSize: 25),),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
          Container(
            child: Icon(Icons.add,size: 50,),
          ),
          SizedBox(height: 20,)
    ],
      ),
    );
  }
}
