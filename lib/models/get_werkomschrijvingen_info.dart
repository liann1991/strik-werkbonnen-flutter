// To parse this JSON data, do
//
//     final Werkomschrijvingen = WerkomschrijvingenFromJson(jsonString);

import 'dart:convert';

Werkomschrijvingen WerkomschrijvingenFromJson(String str) => Werkomschrijvingen.fromJson(json.decode(str));
String WerkomschrijvingenToJson(Werkomschrijvingen data) => json.encode(data.toJson());

class Werkomschrijvingen {
  Werkomschrijvingen({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<WerkomschrijvingData> data;
  String message;

  factory Werkomschrijvingen.fromJson(Map<String, dynamic> json) => Werkomschrijvingen(
    success: json["success"],
    data: List<WerkomschrijvingData>.from(json["data"].map((x) => WerkomschrijvingData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class WerkomschrijvingData {
  WerkomschrijvingData({
    this.id,
    this.omschrijving,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String omschrijving;
  String createdAt;
  String updatedAt;

  factory WerkomschrijvingData.fromRawJson(String str) => WerkomschrijvingData.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory WerkomschrijvingData.fromJson(Map<String, dynamic> json) => WerkomschrijvingData(
    id: json["id"],
    omschrijving: json["omschrijving"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "werkomschrijving": omschrijving,
    "created_at": createdAt,
    "updated_at": updatedAt,

  };
}

