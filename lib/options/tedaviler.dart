import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';

class Tedaviler extends StatefulWidget {
  const Tedaviler({Key? key}) : super(key: key);

  @override
  _TedavilerState createState() => _TedavilerState();
}

class _TedavilerState extends State<Tedaviler> {
  TextEditingController _teshisController = TextEditingController();
  TextEditingController _tedaviController = TextEditingController();
  TextEditingController _veterinerController = TextEditingController();
  TextEditingController _tarihController = TextEditingController();

  CollectionReference _tedavilerRef =
  FirebaseFirestore.instance.collection('tedaviler');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: MyAppBar(),
      body:
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _tedavilerRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> tedaviList =
                      snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: tedaviList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 20), // Boşluk için bir SizedBox ekledik
                    itemBuilder: (context, index) {
                      String teshis = tedaviList[index]['teshis'];
                      String tedavi = tedaviList[index]['tedavi'];
                      String veteriner = tedaviList[index]['veteriner'];
                      Timestamp tarihTimestamp = tedaviList[index]['tarih'];
                      DateTime tarih = tarihTimestamp.toDate();


                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3.0),
                          color: Colors.white70,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Teşhis',
                                    style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    teshis,
                                    style: TextStyle(fontSize: 25, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(
                                    'Tedavi',
                                    style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    tedavi,
                                    style: TextStyle(fontSize: 25, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Veteriner',
                                    style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    veteriner,
                                    style: TextStyle(fontSize: 25, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Tarih',
                                    style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    tarih.toString(),style: TextStyle(fontSize:25 ,color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showEditDialog(  tedaviList[index].reference,
                                      teshis,
                                      tedavi,
                                      veteriner,
                                      tarih,
                                    );
                                  },
                                  icon: Icon(Icons.edit,size: 32,),
                                ),
                                SizedBox(width: 20,),
                                IconButton(
                                  onPressed: () {
                                    _deleteTedavi(tedaviList[index].reference);
                                  },
                                  icon: Icon(Icons.delete,size: 32,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );


                    },
                  );
                },
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.black54,
              onPressed: () {
                _showAddDialog();
              },
              child: Icon(Icons.add,color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Tedavi Ekle'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _teshisController,
                  decoration: InputDecoration(labelText: 'Teşhis'),
                ),
                TextField(
                  controller: _tedaviController,
                  decoration: InputDecoration(labelText: 'Tedavi'),
                ),
                TextField(
                  controller: _veterinerController,
                  decoration: InputDecoration(labelText: 'Veteriner'),
                ),
                TextField(
                  controller: _tarihController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Tarih',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addTedavi();
                _teshisController.clear();
                _tedaviController.clear();
                _veterinerController.clear();
                _tarihController.clear();
              },
              child: Text('Ekle',style: TextStyle(fontSize: 20,color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(DocumentReference reference, String teshis, String tedavi, String veteriner, DateTime tarih) {
    _teshisController.text = teshis;
    _tedaviController.text = tedavi;
    _veterinerController.text = veteriner;
    _tarihController.text = tarih.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Veri Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _teshisController,
                  decoration: InputDecoration(labelText: 'Teşhis'),
                ),
                TextField(
                  controller: _tedaviController,
                  decoration: InputDecoration(labelText: 'Tedavi'),
                ),
                TextField(
                  controller: _veterinerController,
                  decoration: InputDecoration(labelText: 'Veteriner'),
                ),
                TextField(
                  controller: _tarihController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Tarih',
                    suffixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateTedavi(reference);
                _updateTedavi(reference);
                _teshisController.clear();
                _tedaviController.clear();
                _veterinerController.clear();
                _tarihController.clear();
              },
              child: Text('Güncelle',style: TextStyle(fontSize: 20,color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTedavi() async {
    String teshis = _teshisController.text;
    String tedavi = _tedaviController.text;
    String veteriner = _veterinerController.text;
    DateTime tarih = DateTime.parse(_tarihController.text);

    await _tedavilerRef.add({
      'teshis': teshis,
      'tedavi': tedavi,
      'veteriner': veteriner,
      'tarih': Timestamp.fromDate(tarih),
    });

    _teshisController.clear();
    _tedaviController.clear();
    _veterinerController.clear();
    _tarihController.clear();
  }

  Future<void> _updateTedavi(DocumentReference reference) async {
    String teshis = _teshisController.text;
    String tedavi = _tedaviController.text;
    String veteriner = _veterinerController.text;
    DateTime tarih = DateTime.parse(_tarihController.text);

    await reference.update({
      'teshis': teshis,
      'tedavi': tedavi,
      'veteriner': veteriner,
      'tarih': Timestamp.fromDate(tarih),
    });

    _teshisController.clear();
    _tedaviController.clear();
    _veterinerController.clear();
    _tarihController.clear();
  }

  Future<void> _deleteTedavi(DocumentReference reference) async {
    await reference.delete();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        _tarihController.text = picked.toString();
      });
    }
  }
}

