import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';
import 'package:follow_pet/my_widget/table_calendar.dart';


class Asi extends StatefulWidget {
  const Asi({Key? key}) : super(key: key);

  @override
  State<Asi> createState() => _AsiState();
}

class _AsiState extends State<Asi> {
  TextEditingController _asiController = TextEditingController();
  TextEditingController _veterinerController = TextEditingController();
  CollectionReference _asiRef =
  FirebaseFirestore.instance.collection('Asi');

  Future<void> _addAsi(DateTime selectedDate) async {
    String asi = _asiController.text;
    String veteriner = _veterinerController.text;
    DateTime formattedDate =
    DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    await _asiRef.add({
      'asi': asi,
      'veteriner': veteriner,
      'tarih': Timestamp.fromDate(formattedDate),
    });

    _asiController.clear();
    _veterinerController.clear();
  }

  Future<void> _deleteAsi(String asiId) async {
    await _asiRef.doc(asiId).delete();
  }

  void _updateAsi(String asiId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Veri Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _asiController,
                decoration: InputDecoration(labelText: 'Aşı'),
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
                String asi = _asiController.text;
                String veteriner = _veterinerController.text;
                _asiRef.doc(asiId).update({
                  'asi': asi,
                  'veteriner': veteriner,
                });
                _asiController.clear();
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
            Text("* Aşı bilgisi eklemek için tarih seçin.",style: TextStyle(fontSize: 15),),
            Card(
              color: Colors.pink[100],
              child: MyTableCalendar(
                onDaySelected: (selectedDate) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Yeni Aşı Ekle'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _asiController,
                              decoration: InputDecoration(labelText: 'Aşı'),
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
                              _addAsi(selectedDate);
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
                stream: _asiRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> asiList =
                      snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: asiList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      String asiId = asiList[index].id;
                      String asi = asiList[index]['asi'];
                      String veteriner = asiList[index]['veteriner'];
                      Timestamp tarihTimestamp = asiList[index]['tarih'];

                      DateTime tarih = tarihTimestamp.toDate();

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3.0),
                          color: Colors.white70,
                        ),
                        child: ListTile(
                          tileColor: Colors.grey,
                          title: Text(
                            asi,
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
                                onPressed: () => _deleteAsi(asiId),
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () => _updateAsi(asiId),
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