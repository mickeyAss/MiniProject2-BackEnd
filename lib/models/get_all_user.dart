// To parse this JSON data, do
//
//     final getAllUser = getAllUserFromJson(jsonString);

import 'dart:convert';

List<GetAllUser> getAllUserFromJson(String str) => List<GetAllUser>.from(json.decode(str).map((x) => GetAllUser.fromJson(x)));

String getAllUserToJson(List<GetAllUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllUser {
    int uid;
    String name;
    String lastname;
    String phone;
    String password;
    String address;
    String latitude;
    String longitude;
    String img;

    GetAllUser({
        required this.uid,
        required this.name,
        required this.lastname,
        required this.phone,
        required this.password,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.img,
    });

    factory GetAllUser.fromJson(Map<String, dynamic> json) => GetAllUser(
        uid: json["uid"],
        name: json["name"],
        lastname: json["lastname"],
        phone: json["phone"],
        password: json["password"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        img: json["img"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "password": password,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "img": img,
    };
}
