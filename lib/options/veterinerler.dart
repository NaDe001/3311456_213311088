import 'package:flutter/material.dart';
import 'package:follow_pet/model/user_model.dart';
import 'package:follow_pet/my_widget/my_app_bar.dart';
import 'package:http/http.dart' as http;

class Veterinerler extends StatefulWidget {
  const Veterinerler({Key? key}) : super(key: key);

  @override
  State<Veterinerler> createState() => _VeterinerlerState();
}

class _VeterinerlerState extends State<Veterinerler> {
  final url = Uri.parse('https://raw.githubusercontent.com/enderahmetyurt/veterinary-list/master/veterinary-list.json');
  int counter = 0;
  List personalResult = [];
  List filteredResult = [];
  bool isLoading = false;
  String selectedCity = '';

  @override
  void initState() {
    super.initState();
    veteriner();
  }

  Future<void> veteriner() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var result = userFromJson(response.body);
        setState(() {
          counter = result.length;
          personalResult = result;
          filteredResult = result;
          isLoading = true;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void filterByCity(String city) {
    setState(() {
      selectedCity = city;
      if (city.isNotEmpty) {
        filteredResult = personalResult.where((user) => user.city == city).toList();
        counter = filteredResult.length;
      } else {
        filteredResult = personalResult;
        counter = personalResult.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: MyAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading == false
              ? const CircularProgressIndicator()
              : Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCity,
                onChanged: (value) {
                  filterByCity(value!);
                },
                items: [
                  DropdownMenuItem(
                    child: const Text('Tüm Şehirler'),
                    value: '',
                  ),
                  for (var city in getAllCities()) // Bütün şehirleri döngü ile ekleyin
                    DropdownMenuItem(
                      child: Text(city),
                      value: city,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: counter,
                  itemBuilder: (context, index) {
                    final user = filteredResult[index];
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 3.0,
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity, // Tam genişlik almasını sağlar
                                  child: Text(
                                    'Telefon: ${user.telephone}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity, // Tam genişlik almasını sağlar
                                  child: Text(
                                    'Şehir: ${user.city}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity, // Tam genişlik almasını sağlar
                                  child: Text(
                                    'Adres: ${user.address}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List getAllCities() {
    // Bütün şehirleri içeren bir liste döndürür
    return personalResult.map((user) => user.city).toSet().toList();
  }
}
