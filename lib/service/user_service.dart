import 'dart:convert';

import 'package:follow_pet/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserService{
  final String url= 'https://raw.githubusercontent.com/enderahmetyurt/veterinary-list/master/veterinary-list.json';
  Future<UserModelData?> fetchUser() async {
    var res = await http.get(Uri.parse(url));
    if(res.statusCode <= 200){
      var jsonBody= UserModelData.fromJson(jsonDecode(res.body));
      return jsonBody;
          
    }else{
      print("istek başarısız oldu => ${res.statusCode}");
    }
    return null;


  }
}