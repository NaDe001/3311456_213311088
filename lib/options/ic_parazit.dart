import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';
import '../my_widget/table_calendar.dart';

class Ic_Parazit extends StatefulWidget {
  const Ic_Parazit({Key? key}) : super(key: key);

  @override
  _Ic_ParazitState createState() => _Ic_ParazitState();
}

class _Ic_ParazitState extends State<Ic_Parazit> {
  TextEditingController _parazitController = TextEditingController();
  TextEditingController _veterinerController = TextEditingController();
  CollectionReference _parazitRef =
  FirebaseFirestore.instance.collection('Parazit');

  Future<void> _addParazit(DateTime selectedDate) async {
    String parazit = _parazitController.text;
    String veteriner = _veterinerController.text;
    DateTime formattedDate =
    DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    await _parazitRef.add({
      'parazit': parazit,
      'veteriner': veteriner,
      'tarih': Timestamp.fromDate(formattedDate),
    });

    _parazitController.clear();
    _veterinerController.clear();
  }

  Future<void> _deleteParazit(String parazitId) async {
    await _parazitRef.doc(parazitId).delete();
  }

  void _updateParazit(String parazitId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Veri Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _parazitController,
                decoration: InputDecoration(labelText: 'Parazit'),
              ),
              TextField(
                controller: _veterinerController,
                decoration: InputDecoration(labelText: 'Veteriner'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                String parazit = _parazitController.text;
                String veteriner = _veterinerController.text;
                _parazitRef.doc(parazitId).update({
                  'parazit': parazit,
                  'veteriner': veteriner,
                });
                _parazitController.clear();
                _veterinerController.clear();
              },
              child: Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: MyAppBar(),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("* Parazit bilgisi eklemek için tarih seçin.",style: TextStyle(fontSize: 15),),
            Card(
              color: Colors.pink[100],
              child: MyTableCalendar(
                onDaySelected: (selectedDate) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Yeni Parazit Ekle'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _parazitController,
                              decoration: InputDecoration(labelText: 'Parazit'),
                            ),
                            TextField(
                              controller: _veterinerController,
                              decoration: InputDecoration(labelText: 'Veteriner'),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _addParazit(selectedDate);
                            },
                            child: Text('Ekle'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _parazitRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> parazitList =
                      snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: parazitList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      String parazitId = parazitList[index].id;
                      String parazit = parazitList[index]['parazit'];
                      String veteriner = parazitList[index]['veteriner'];
                      Timestamp tarihTimestamp = parazitList[index]['tarih'];

                      DateTime tarih = tarihTimestamp.toDate();

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3.0),
                          color: Colors.white70,
                        ),
                        child: ListTile(
                          tileColor: Colors.grey,
                          title: Text(
                            parazit,
                            style: TextStyle(fontSize: 23),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                veteriner,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 15),
                              Text(
                                tarih.toString(), // Tarihi direkt olarak kullanın
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _deleteParazit(parazitId),
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () => _updateParazit(parazitId),
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
