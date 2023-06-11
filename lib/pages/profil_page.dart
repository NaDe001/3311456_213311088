import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _age;
  late String _animal;
  late String _genus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Adı'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen adını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Yaşı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen yaşını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Türü'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen Hayvan Türünü Girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _animal = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cinsi'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen cinsini girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _genus = value!;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey,
                              title: Text('Profil Bilgileriniz'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('Adı: $_name'),
                                    Text('Yaşı: $_age'),
                                    Text('Cinsi: $_animal'),
                                    Text('Türü: $_genus'),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Tamam'),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
