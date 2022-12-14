import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_backend/api/my_api.dart';
import 'package:flutter_app_backend/components/text_widget.dart';
import 'package:flutter_app_backend/pages/werkbonnen/werkbonnen_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  _showMsg(msg) { //
    final snackBar = SnackBar(
      backgroundColor: Color(0xFF363f93),
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _login() async {
    var data = {
      'email' : emailController.text,
      'password' : textController.text,
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
     localStorage.setString('token', body['token']);
      localStorage.setString('logintoken', body['logintoken']);
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('username', json.encode(body['user']['name']));
      print(localStorage.getString('username'));
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => WerkbonnenPage()));
    }else{
      _showMsg(body['message']);
    }
  }
  @override
  Widget build(BuildContext context) {
    final double height= MediaQuery.of(context).size.height;
    return
      Scaffold(
        backgroundColor: Color(0xFFffffff),
        body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 40),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:height*0.1),
            Container(
              padding: const EdgeInsets.only(left:0, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      padding:EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon:

                      Icon(Icons.arrow_back_ios, color:Color(0xFF363f93)),
                      onPressed:()=>Navigator.of(context, rootNavigator: true).pop(context))
                ],
              ),
            ),
            SizedBox(height:height*0.1),
            TextWidget(text:"Welkom!", fontSize:26, isUnderLine:false),
            SizedBox(height:height*0.1),
            TextInput(textString:"Email", textController:emailController, hint:"Emailadres"),
            SizedBox(height: height*.05,),
            TextInput(textString:"Password", textController:textController, hint:"Wachtwoord", obscureText: true,),
            SizedBox(height: height*.05,),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.lightBlue,
              ),
              onPressed: () {
                _login();
              },
              icon: Icon(Icons.arrow_forward, size: 22),
              label: Text("Inloggen"),
            ),
    ],
        ),
        )
      ),
      );
  }
}


class TextInput extends StatelessWidget {
  final String textString;
  TextEditingController textController;
  final String hint;
  bool obscureText;
  TextInput({Key key, this.textString, this.textController, this.hint, this.obscureText=false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Color(0xFF000000)),
      cursorColor: Color(0xFF9b9b9b),
      controller: textController,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(

        hintText: this.textString,
        hintStyle: TextStyle(
            color: Color(0xFF9b9b9b),
            fontSize: 15,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}

