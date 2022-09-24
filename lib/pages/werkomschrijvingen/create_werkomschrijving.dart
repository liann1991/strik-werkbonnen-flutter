import 'package:flutter/material.dart';
import 'package:flutter_app_backend/pages/werkomschrijvingen/werkomschrijvingen_page.dart';
import '../../api/my_api.dart';
import '../../components/menu.dart';
import '../../models/get_werkomschrijvingen_info.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:settings_ui/pages/settings.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: CreateWerkomschrijvingPage(),
    );
  }
}

class CreateWerkomschrijvingPage extends StatefulWidget {
  final WerkomschrijvingData werkomschrijvingen;
  final int index;

  CreateWerkomschrijvingPage({Key key, this.werkomschrijvingen, this.index}) : super(key: key);

  @override
  _CreateWerkomschrijvingPageState createState() => _CreateWerkomschrijvingPageState();
}

postOmschrijving(data) async {
  CallApi().postOmschrijvingData(data, "werkomschrijving");
  print('gelukt!');
}

class FormModel {
  String omschrijving;
  FormModel({this.omschrijving});
}

class _CreateWerkomschrijvingPageState extends State<CreateWerkomschrijvingPage> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  var userInfo = '';
  bool _omschrijvingHasError = false;
  final _formKey = GlobalKey<FormBuilderState>();
  final model = FormModel();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('nl_NL', null);

    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Nieuwe werkomschrijving"),
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState.save();
                  debugPrint(_formKey.currentState.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'omschrijving',
                    decoration: InputDecoration(
                      labelText: 'Werkomschrijving',
                      suffixIcon: _omschrijvingHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _omschrijvingHasError = !(_formKey.currentState?.fields['omschrijving']
                            ?.validate() ??
                            false);
                      });
                    },
                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(120),
                    ]),
                  onSaved: (value){
                      model.omschrijving = value;
                  },
                    // initialValue: '12',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          _formKey.currentState.save();
                          postOmschrijving(model.omschrijving.toString());
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => WerkomschrijvingenPage()));
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  }