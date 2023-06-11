import 'dart:convert';

List<UserModelData> userFromJson(String str) => List<UserModelData>.from(json.decode(str).map((x) => UserModelData.fromJson(x)));

String userToJson(List<UserModelData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class UserModelData {
  String? name;
  String? address;
  String? city;
  String? town;
  String? telephone;
  String? website;
  String? email;

  UserModelData(
      {this.name,
        this.address,
        this.city,
        this.town,
        this.telephone,
        this.website,
        this.email});

  UserModelData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    city = json['city'];
    town = json['town'];
    telephone = json['telephone'];
    website = json['website'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['address'] = address;
    data['city'] = this.city;
    data['town'] = this.town;
    data['telephone'] = telephone;
    data['website'] = this.website;
    data['email'] = this.email;
    return data;
  }
}