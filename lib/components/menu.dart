import 'package:flutter/material.dart';
import '../pages/werkbonnen/werkbonnen_page.dart';
import '../pages/werkomschrijvingen/werkomschrijvingen_page.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Strik Werkbonnen',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage("img/strik_logo.png"))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Gebruikers'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Werkbonnen'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WerkbonnenPage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Werkomschrijvingen'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => WerkomschrijvingenPage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Instellingen'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }

  // _showMsg(msg) { //
  //   final snackBar = SnackBar(
  //     backgroundColor: Color(0xFF363f93),
  //     content: Text(msg),
  //     action: SnackBarAction(
  //       label: 'Close',
  //       onPressed: () {
  //         // Some code to undo the change!
  //       },
  //     ),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
  //
  // signOut() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var logintoken = localStorage.getString('logintoken');
  //
  //   var data = {
  //     'logintoken' : logintoken,
  //   };
  //
  //   var res = await CallApi().postData(data, 'logout');
  //   var body = json.decode(res.body);
  //   print(body);
  //   if(body['success']){
  //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     localStorage.setString('token', null);
  //     localStorage.setString('logintoken', null);
  //     localStorage.setString('user', null);
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(
  //             builder: (context) => SignIn()));
  //   }else{
  //     _showMsg(body['message']);
  //   }
  // }
}