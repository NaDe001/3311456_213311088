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
  late List personalResult;
  bool? isLoading;

  @override
  void initState() {
    super.initState();
    veteriner();
  }

  Future<void> veteriner() async {
    try {
      final response = await http.get(url);
      if (response.statusCode <=200) {
        var result = userFromJson(response.body);
        isLoading = true;
        if (mounted) {
          setState(() {
            counter = result.length;
            personalResult = result;
          });
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: MyAppBar(),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: isLoading == null
                ? const CircularProgressIndicator()  :
               ListView.builder(
                    itemCount: counter,
                    itemBuilder: (context, index) {
                      final user = personalResult[index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: (Colors.black), width: 3.0),
                                color: Colors.white),
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Telefon: ${user.telephone}',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[850]),
                                  ),                                  Text(
                                    'Şehir: ${user.city}',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[850]),
                                  ),
                                  Text(
                                    'Adres: ${user.address}',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[850]),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
