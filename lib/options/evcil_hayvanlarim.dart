import 'package:flutter/material.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class Animal {
  int? id;
  String name;
  int age;
  String species;

  Animal(
      {this.id, required this.name, required this.age, required this.species});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'species': species,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path!, 'animals.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE animals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        species TEXT
      )
    ''');
  }

  Future<List<Animal>> getAnimals() async {
    final db = await instance.database;
    final maps = await db.query('animals');

    return List.generate(maps.length, (i) {
      return Animal(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        age: maps[i]['age'] as int,
        species: maps[i]['species'] as String,
      );
    });
  }

  Future<int> insertAnimal(Animal animal) async {
    final db = await instance.database;
    return await db.insert('animals', animal.toMap());
  }

  Future<int> updateAnimal(Animal animal) async {
    final db = await instance.database;
    return await db.update(
      'animals',
      animal.toMap(),
      where: 'id = ?',
      whereArgs: [animal.id],
    );
  }

  Future<int> deleteAnimal(int id) async {
    final db = await instance.database;
    return await db.delete(
      'animals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimalPage(),
    );
  }
}

class AnimalPage extends StatefulWidget {
  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _speciesController = TextEditingController();

  List<Animal> _animals = [];

  @override
  void initState() {
    super.initState();
    _refreshAnimalList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _speciesController.dispose();
    super.dispose();
  }

  Future<void> _refreshAnimalList() async {
    final animals = await DatabaseHelper.instance.getAnimals();
    setState(() {
      _animals = animals;
    });
  }

  Future<void> _addAnimal() async {
    final animal = Animal(
      name: _nameController.text,
      age: int.parse(_ageController.text),
      species: _speciesController.text,
    );
    await DatabaseHelper.instance.insertAnimal(animal);
    _clearForm();
    _refreshAnimalList();
  }

  Future<void> _updateAnimal(Animal animal) async {
    final updatedAnimal = Animal(
      id: animal.id,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      species: _speciesController.text,
    );

    await DatabaseHelper.instance.updateAnimal(updatedAnimal);

    _clearForm();
    _refreshAnimalList();
  }

  Future<void> _deleteAnimal(Animal animal) async {
    await DatabaseHelper.instance.deleteAnimal(animal.id!);
    _refreshAnimalList();
  }

  void _clearForm() {
    _formKey.currentState!.reset();
  }

  void _populateForm(Animal animal) {
    _nameController.text = animal.name;
    _ageController.text = animal.age.toString();
    _speciesController.text = animal.species;
  }

  void _showDeleteConfirmationDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Animal'),
          content: Text('Are you sure you want to delete this animal?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteAnimal(animal);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateAlertDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Update Animal'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the animal name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the animal age';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _speciesController,
                    decoration: InputDecoration(labelText: 'Species'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the animal species';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateAnimal(animal);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.blue[50],
      body: RefreshIndicator(
        onRefresh: _refreshAnimalList,
        child: ListView.builder(
            itemCount: _animals.length,
            itemBuilder: (context, index) {
              Animal animal = _animals[index];
              return ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animal.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Türü: ${animal.species}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Yaşı: ${animal.age}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                          height:
                              10.0), // Iconlar ile bilgiler arasında boşluk bırakmak için
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _populateForm(animal);
                                _showUpdateAlertDialog(context, animal);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, animal);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.text = ''; // İsim alanını temizle
          _speciesController.text = ''; // Tür alanını temizle
          _ageController.text = ''; // Yaş alanını temizle
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Animal'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Adı'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the animal name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Yaşı'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the animal age';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _speciesController,
                          decoration: InputDecoration(labelText: 'Türü'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the animal species';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Vazgeç'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Kaydet'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addAnimal();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
