import 'dart:convert';
import 'dart:math';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_backend/api/my_api.dart';
import 'package:flutter_app_backend/components/text_widget.dart';
import 'package:flutter_app_backend/models/get_werkbonnen_info.dart';
import 'package:flutter_app_backend/models/get_werkomschrijvingen_info.dart';
import 'package:flutter_app_backend/pages/werkbonnen/edit_werkbonnen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/menu.dart';
import 'create_werkbonnen.dart';
import 'detail_werkbonnen.dart';

class WerkbonnenPage extends StatefulWidget {
  const WerkbonnenPage({Key key}) : super(key: key);

  @override
  _WerkbonnenPageState createState() => _WerkbonnenPageState();
}

class _WerkbonnenPageState extends State<WerkbonnenPage> {
  var werkbonnen = <Werkbon>[];
  var allwerkbonnen = <Werkbon>[];
  var userInfo = '';

  @override
  void initState() {
    _getWerkbonnen();
    super.initState();
  }
  
  _getWerkbonnen() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("username");
    if(user!=null){
        setState(() {
          userInfo = user;
          debugPrint(userInfo);
        });
    }else{
      setState(() {
      debugPrint("no info");
    });
    }
    await _initData();
  }
  _initData() async {
    CallApi().getPublicData("werkbonnen").then((response){
      // print(json.decode(response.body)['data']);
      setState(() {
        // List list = (jsonDecode(response.body)['data'] as List<dynamic>) ;
        Iterable list = json.decode(response.body)['data'];
        werkbonnen= list.map((model)=>Werkbon.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: Menu(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Werkbonnen overzicht"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
            // SearchBar(onSearch: onSearch, onItemFound: onItemFound),
          ],
        ),
        body: Container(
          color:Colors.white,
          child: SafeArea(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left:20, right: 100, top:20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                            text:"Datum:",
                            fontSize: 16,
                            color:Colors.black
                        ),
                        TextWidget(
                            text:"Omschrijving:",
                            fontSize: 16,
                            color:Colors.black
                        ),
                        TextWidget(
                            text:"Totaaltijd:",
                            fontSize: 16,
                            color:Colors.black
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateWerkbonnenPage()),
                            );
                          },
                          icon: Icon(Icons.add, size: 20),
                          label: Text("Nieuwe werkbon"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Expanded(
                    child: SingleChildScrollView(
                      child:werkbonnen.length==0?CircularProgressIndicator(): Column(
                        children: werkbonnen.map((werkbon){
                          return GestureDetector(
                              onTap:(){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>DetailWerkbonnenPage(werkbonnen:werkbon, index:0))
                                );
                              },
                              child:Container(
                                  padding: const EdgeInsets.only(left:20, right: 100),
                                  height: 170,
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 0.2, color: Colors.black),
                                      )
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          TextWidget(
                                              text:DateFormat('dd-MM-yyyy').format(werkbon.datum),
                                              fontSize: 16,
                                              color:Colors.black
                                          ),
                                          TextWidget(
                                              text:werkbon.werkomschrijving.omschrijving,
                                              fontSize: 16,
                                              color:Colors.black
                                          ),
                                          TextWidget(
                                              text:werkbon.totaaltijdDag,
                                              fontSize: 16,
                                              color:Colors.black
                                          ),
                                          Container(
                                              padding: const EdgeInsets.only(top: 20),
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ElevatedButton.icon(
                                                    style: ElevatedButton.styleFrom(
                                                      onPrimary: Colors.white,
                                                      primary: Colors.lightBlue,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => EditWerkbonnenPage(werkbonnen:werkbon, index:0)),
                                                      );
                                                    },
                                                    icon: Icon(Icons.edit, size: 22),
                                                    label: Text("Wijzigen"),
                                                  ),
                                                  Divider(
                                                      color:Colors.white
                                                  ),
                                                  ElevatedButton.icon(
                                                    style: ElevatedButton.styleFrom(
                                                      onPrimary: Colors.white,
                                                      primary: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      // Respond to button press
                                                    },
                                                    icon: Icon(Icons.delete, size: 20),
                                                    label: Text("Verwijderen"),
                                                  ),
                                                ],
                                              )
                                          )
                                        ],
                                      ),

                                    ],
                                  )

                              )

                          );
                        }).toList(),
                      ),

                    ),
                  ),
                ],
              )
          ),
        )
    );
  }
}
