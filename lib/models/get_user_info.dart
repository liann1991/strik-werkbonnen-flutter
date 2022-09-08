// To parse this JSON data, do
//
//     final User = UserFromJson(jsonString);

import 'dart:convert';

User UserFromJson(String str) => User.fromJson(json.decode(str));
String UserToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<UserData> data;
  String message;

  factory User.fromJson(Map<String, dynamic> json) => User(
    success: json["success"],
    data: json["data"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "message": message,
  };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.userpicture,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String userpicture;
  String email;
  dynamic emailVerifiedAt;
  String createdAt;
  String updatedAt;

  factory UserData.fromRawJson(String str) => UserData.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    name: json["name"],
    userpicture: json["userpicture"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userpicture": userpicture,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

