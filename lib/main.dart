import 'package:flutter/material.dart';
import 'package:flutter_app_backend/welcome/welcome_page.dart';
import 'package:form_builder_validators/localization/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strik Werkbonnen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.black,
      ),
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
        ],
      home: WelcomePage(),
    );
  }
}
