import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CallApi{
  final String _url = 'https://login.strik-elektrotechniek.nl/api/';
  final String _imgUrl='https://login.strik-elektrotechniek.nl/assets/img/';
  getImage(){
    return _imgUrl;
  }
  postData(data, apiUrl) async {
    var token = await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
  }
  postOmschrijvingData(data, apiUrl) async {
    var token = await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl),
      headers:
      {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'omschrijving': data,
      }),
    );
  }
  postWerkbonData(weeknummer, datum, omschrijving, begintijd, pauze, eindtijd, totaaltijd, apiUrl) async {
    var token = await _getToken();
    var fullUrl = _url + apiUrl;
    var body = jsonEncode({
      'weeknummer': weeknummer,
      'datum': datum,
      'omschrijving': omschrijving,
      'begintijd': begintijd,
      'pauze': pauze,
      'eindtijd': eindtijd,
      'totaaltijd': totaaltijd,
    });
    print('dit is de body: $body');
    return await http.post(
      Uri.parse(fullUrl),
      headers:
      {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      },
      body: jsonEncode({
      'weeknummer': weeknummer,
      'datum': datum,
      'omschrijving': omschrijving,
      'begintijd': begintijd,
      'pauze': pauze,
      'eindtijd': eindtijd,
      'totaaltijd': totaaltijd,
      }),
    );
  }
  getData(apiUrl) async {
    var token = await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');
    return '$token';
  }


  getCurrentUser(apiUrl) async {
    var token = await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
  }

  getPublicData(apiUrl) async {
    var token = await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
  }

}