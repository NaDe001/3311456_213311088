import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _imageFile;

  String _name = '';
  String _breed = '';
  String _gender = '';
  String _birthDate = '';
  String _animalType = '';
  String _age = '';

  Map<String, dynamic>? profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('Profile').doc('Profile').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Hata: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            profileData = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 3.0,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (profileData!['resim'] != null
                              ? NetworkImage(profileData!['resim'] ?? '')as ImageProvider<Object>?
                              : NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/follow-pet-68b31.appspot.com/o/resim%2FPolish_20210711_154405946.jpg?alt=media&token=ac9f78df-609e-4cc6-8047-429e175d3eac')),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    _buildProfileField(
                      label: 'İsim',
                      value: _name.isNotEmpty ? _name : profileData!['isim'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    _buildProfileField(
                      label: 'Cinsi',
                      value: _breed.isNotEmpty ? _breed : profileData!['cinsi'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          _breed = value;
                        });
                      },
                    ),
                    _buildProfileField(
                      label: 'Cinsiyet',
                      value: _gender.isNotEmpty ? _gender : profileData!['cinsiyeti'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    _buildProfileField(
                      label: 'Doğum Tarihi',
                      value: _birthDate.isNotEmpty ? _birthDate : profileData!['dtarih'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          _birthDate = value;
                        });
                      },
                    ),
                    _buildProfileField(
                      label: 'Hayvan Türü',
                      value: _animalType.isNotEmpty ? _animalType : profileData!['hayvan'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          _animalType = value;
                        });
                      },
                    ),
                    _buildProfileField(
                      label: 'Yaş',
                      value: _birthDate.isNotEmpty ? _birthDate : profileData!['yas'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          _age = value;
                        });
                      },
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white70),
                            minimumSize: MaterialStateProperty.all<Size>(Size(50, 30),),
                          ),
                          onPressed: _updateProfile,
                          child: Text(
                            'Profil Güncelle',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 20,
          color: Colors.black54,
        ),
      ),
      style: TextStyle(
        fontSize: 21,
        color: Colors.black,
      ),
      onChanged: onChanged,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userId = auth.currentUser!.uid;
        final profileRef = _firestore.collection('Profile').doc('Profile');

        Map<String, dynamic> updatedData = {};

        if (_imageFile != null) {
          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(userId);

          await storageRef.putFile(_imageFile!);
          final downloadUrl = await storageRef.getDownloadURL();

          updatedData['resim'] = downloadUrl;
        }

        if (_name.isNotEmpty) {
          updatedData['isim'] = _name;
        }

        if (_breed.isNotEmpty) {
          updatedData['cinsi'] = _breed;
        }

        if (_gender.isNotEmpty) {
          updatedData['cinsiyeti'] = _gender;
        }

        if (_birthDate.isNotEmpty) {
          updatedData['dtarih'] = _birthDate;
        }

        if (_animalType.isNotEmpty) {
          updatedData['hayvan'] = _animalType;
        }

        if (_age.isNotEmpty) {
          updatedData['yas'] = _age;
        }

        await profileRef.update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profil güncellendi'),
        ));
      } catch (e) {
        print('Profil güncelleme hatası: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hata: Profil güncellenirken bir hata oluştu'),
        ));
      }
    }
  }
}
