import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';

class KiloTakip extends StatefulWidget {
  @override
  _KiloTakipState createState() => _KiloTakipState();
}

class _KiloTakipState extends State<KiloTakip> with SingleTickerProviderStateMixin {
  List<String> aylar = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.blue[50],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: FadeTransition(
              opacity: _animation,
              child: Text(
                'Kilomuzu Takip Edelim',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('KiloTakip').doc('KiloTakip').get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Veriler alınamadı: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.data!.data();

                return ListView.builder(
                  itemCount: aylar.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ay = aylar[index];
                    final kilo = data != null ? (data[ay] as String?) : '';

                    return Card(
                      child: ListTile(
                        title: Text(
                          ay,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        ),
                        subtitle: Text(
                          '$kilo kg',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange[900]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String newKilo = kilo ?? '';
                              return AlertDialog(
                                title: Text(
                                  ay,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red[900]),
                                ),
                                content: TextFormField(
                                  initialValue: kilo,
                                  onChanged: (value) {
                                    newKilo = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Kaydet'),
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection('KiloTakip').doc('KiloTakip').update({
                                        ay: newKilo,
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
