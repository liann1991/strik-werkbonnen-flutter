import 'dart:convert';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_backend/api/my_api.dart';
import 'package:flutter_app_backend/components/text_widget.dart';
import 'package:flutter_app_backend/models/get_werkomschrijvingen_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/menu.dart';
import 'create_werkomschrijving.dart';
import 'detail_werkomschrijving.dart';
import 'edit_werkomschrijving.dart';

class WerkomschrijvingenPage extends StatefulWidget {
  const WerkomschrijvingenPage({Key key}) : super(key: key);

  @override
  _WerkomschrijvingenPageState createState() => _WerkomschrijvingenPageState();
}

class _WerkomschrijvingenPageState extends State<WerkomschrijvingenPage> {
  var werkomschrijvingen = <WerkomschrijvingData>[];
  var allwerkomschrijvingen = <WerkomschrijvingData>[];

  @override
  void initState() {
    _getWerkomschrijvingen();
    super.initState();
  }
  
  _getWerkomschrijvingen() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    if(user!=null){
        setState(() {
          var userInfo= jsonEncode(user);
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
    CallApi().getPublicData("werkomschrijving").then((response){
      // print(json.decode(response.body)['data']);
      setState(() {
        // List list = (jsonDecode(response.body)['data'] as List<dynamic>) ;
        Iterable list = json.decode(response.body)['data'];
        werkomschrijvingen= list.map((model)=>WerkomschrijvingData .fromJson(model)).toList();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: Menu(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Werkomschrijvingen overzicht'),
        ),
        body: Container(
          color:Colors.white,
          child: SafeArea(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height*0.02,),
                  Container(
                    padding: const EdgeInsets.only(left:20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon:

                            Icon(Icons.arrow_back_ios, color:Color(0xFF363f93)),
                            onPressed:()=> Navigator.pop(context)),
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon:

                            Icon(Icons.home_outlined, color:Color(0xFF363f93)),
                            onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WerkomschrijvingenPage()))),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left:20, right: 0, top:20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                        child: TextWidget(
                            text:"Aangemaakt:",
                            fontSize: 14,
                            color:Colors.black
                        ),
                        ),
                        Flexible(
                        child: TextWidget(
                            text:"Omschrijving:",
                            fontSize: 14,
                            color:Colors.black
                        ),
                        ),
                        Flexible(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateWerkomschrijvingPage()),
                            );
                          },
                          icon: Icon(Icons.add, size: 20),
                          label: Text(""),
                        ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Expanded(
                    child: SingleChildScrollView(
                      child:werkomschrijvingen.length==0?CircularProgressIndicator(): Column(
                        children: werkomschrijvingen.map((werkomschrijvingen){
                          return GestureDetector(
                              onTap:(){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>DetailWerkomschrijvingPage(werkomschrijvingen:werkomschrijvingen, index:0))
                                );
                              },
                              child:Container(
                                  padding: const EdgeInsets.only(left:20, right: 20),
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
                                          Flexible(
                                          child: TextWidget(
                                              text:werkomschrijvingen.createdAt,
                                              fontSize: 14,
                                              color:Colors.black
                                          ),
                                          ),
                                          Flexible(
                                          child: TextWidget(
                                              text:werkomschrijvingen.omschrijving,
                                              fontSize: 14,
                                              color:Colors.black
                                          ),
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
                                                        MaterialPageRoute(builder: (context) => EditWerkomschrijvingPage(werkomschrijvingen:werkomschrijvingen, index:0)),
                                                      );
                                                    },
                                                    icon: Icon(Icons.edit, size: 20),
                                                    label: Text(""),
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
                                                        CallApi().deleteData(werkomschrijvingen.id, "werkomschrijving");
                                                          Fluttertoast.showToast(
                                                              msg: "De omschrijving is succesvol verwijderd",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.red,
                                                              textColor: Colors.white,
                                                              fontSize: 14
                                                      );
                                                        Navigator.pop(context);
                                                        Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) => WerkomschrijvingenPage()));
                                                    },
                                                    icon: Icon(Icons.delete, size: 20),
                                                    label: Text(""),
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
