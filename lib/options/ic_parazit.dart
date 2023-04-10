import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';
import '../my_widget/table_calendar.dart';


class Ic_Parazit extends StatefulWidget {
  @override
  State<Ic_Parazit> createState() => _Ic_ParazitState();
}

class _Ic_ParazitState extends State<Ic_Parazit> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[100],
      appBar: MyAppBar(),
      body: Column(
        children: [
          Column(
            children: [
             MyTableCalenar(),
            ],
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 180,
                      height: 40,
                      color: Colors.white70,
                      child: Text("SERA İç Przt",style: TextStyle(fontStyle: FontStyle.normal,fontSize: 28),)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 180,
                    height: 40,
                    color: Colors.white70,
                    child: Text("ABC Veteriner",style: TextStyle(fontStyle: FontStyle.normal,fontSize: 28)),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
