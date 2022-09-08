// To parse this JSON data, do
//
//     final werkbonnen = werkbonnenFromJson(jsonString);

import 'dart:convert';

Werkbonnen werkbonnenFromJson(String str) => Werkbonnen.fromJson(json.decode(str));
String werkbonnenToJson(Werkbonnen data) => json.encode(data.toJson());

class Werkbonnen {
  Werkbonnen({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Werkbon> data;
  String message;

  factory Werkbonnen.fromJson(Map<String, dynamic> json) => Werkbonnen(
    success: json["success"],
    data: List<Werkbon>.from(json["data"].map((x) => Werkbon.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Werkbon {
  Werkbon({
    this.id,
    this.werkomschrijvingId,
    this.werkomschrijving,
    this.weeknummer,
    this.datum,
    this.begintijd,
    this.eindtijd,
    this.pauze,
    this.totaaltijdDag,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int werkomschrijvingId;
  Werkomschrijving werkomschrijving;
  int weeknummer;
  DateTime datum;
  String begintijd;
  String eindtijd;
  String pauze;
  String totaaltijdDag;
  String createdAt;
  String updatedAt;

  factory Werkbon.fromRawJson(String str) => Werkbon.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Werkbon.fromJson(Map<String, dynamic> json) => Werkbon(
    id: json["id"],
    werkomschrijvingId: json["werkomschrijving_id"],
    werkomschrijving: Werkomschrijving.fromJson(json["werkomschrijving"]),
    weeknummer: json["weeknummer"],
    datum: DateTime.tryParse(json["datum"].toString()),
    begintijd: json["begintijd"],
    eindtijd: json["eindtijd"],
    pauze: json["pauze"],
    totaaltijdDag: json["totaaltijd_dag"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {

    "id": id,
    "werkomschrijving_id": werkomschrijvingId,
    "werkomschrijving": werkomschrijving.toJson(),
    "weeknummer": weeknummer,
    "datum": datum,
    // "datum": "${datum.year.toString().padLeft(4, '0')}-${datum.month.toString().padLeft(2, '0')}-${datum.day.toString().padLeft(2, '0')}",
    "begintijd": begintijd,
    "eindtijd": eindtijd,
    "pauze": pauze,
    "totaaltijd_dag": totaaltijdDag,
    "created_at": createdAt,
    "updated_at": updatedAt,

  };
}

class Werkomschrijving {
  Werkomschrijving({
    this.id,
    this.omschrijving,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String omschrijving;
  String createdAt;
  String updatedAt;

  factory Werkomschrijving.fromJson(Map<String, dynamic> json) => Werkomschrijving(
    id: json["id"],
    omschrijving: json["omschrijving"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "omschrijving": omschrijving,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

