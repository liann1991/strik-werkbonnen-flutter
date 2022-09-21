import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/my_api.dart';
import '../../components/menu.dart';
import '../../models/get_werkbonnen_info.dart';
import '../../models/get_werkomschrijvingen_info.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:settings_ui/pages/settings.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: CreateWerkbonnenPage(),
    );
  }
}

class CreateWerkbonnenPage extends StatefulWidget {
  final Werkbon werkbonnen;
  final WerkomschrijvingData werkomschrijvingen;
  final int index;

  CreateWerkbonnenPage({Key key, this.werkbonnen, this.werkomschrijvingen, this.index}) : super(key: key);

  @override
  _CreateWerkbonnenPageState createState() => _CreateWerkbonnenPageState();
}

postWerkbon(weeknummer, datum, omschrijving, begintijd, pauze, eindtijd, totaaltijd) async {
  CallApi().postWerkbonData(weeknummer, datum, omschrijving, begintijd, pauze, eindtijd, totaaltijd, "werkbonnen");
  print('gelukt!, $weeknummer, $datum, $omschrijving, $begintijd, $pauze, $eindtijd, $totaaltijd');
}

class FormModel {
  int weeknummer;
  DateTime datum;
  String omschrijving;
  DateTime begintijd;
  DateTime pauze;
  DateTime eindtijd;
  DateTime totaaltijd;
  FormModel({this.weeknummer, this.datum, this.omschrijving, this.begintijd, this.pauze, this.eindtijd, this.totaaltijd});
}

class _CreateWerkbonnenPageState extends State<CreateWerkbonnenPage> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  var userInfo = '';
  final _formKey = GlobalKey<FormBuilderState>();
  final model = FormModel();
  bool _genderHasError = false;

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }
  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    model.weeknummer = woy;
  }

  @override
  void initState() {
    _getWerkomschrijvingen();
    super.initState();
  }

  _getWerkomschrijvingen() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("username");
    if(user!=null){
      setState(() {
        userInfo = user;
      });
    }else{
      setState(() {
        debugPrint("no info");
      });
    }
    await _initData();
  }

  List werkomschrijvingen = [];

  _initData() async {
    CallApi().getPublicData("werkomschrijving").then((response){
      var resBody = json.decode(response.body)['data'];
      setState(() {
        werkomschrijvingen = resBody;
      });
    });
  }

  getTotaaltijd(begintijd, eindtijd, pauze) {
    var totaaltijd = null;
    var hours1 = eindtijd.toString().substring(11,13);
    var hours2 = pauze.toString().substring(11,13);
    var hours3 = begintijd.toString().substring(11,13);
    var hours = int.parse(hours1) - int.parse(hours2) - int.parse(hours3);
    var minute1 = eindtijd.toString().substring(14,16);
    var minute2 = pauze.toString().substring(14,16);
    var minute3 = begintijd.toString().substring(14,16);
    var minutes = int.parse(minute1) - int.parse(minute2) - int.parse(minute3);

    if(minutes<0){
      hours--;
      minutes = 60 + minutes;
      if(minutes<0){
        hours--;
        minutes = 60 + minutes;
      }
    }
    var MinuteString = minutes < 10 ? "0" + minutes.toString() : minutes.toString();
    var HourString = hours < 10 ? "0" + hours.toString() : hours.toString();
    var tijd = "0001-01-01 " + HourString + ':' + MinuteString + ':00.000';
    totaaltijd = DateTime.parse(tijd);
    model.totaaltijd = totaaltijd;
    _formKey.currentState.fields['totaaltijd'].didChange(totaaltijd);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('nl_NL', null);

    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Nieuwe werkbon"),
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
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      name: 'datum',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      format: DateFormat('dd-MM-yyyy'),
                      // enabled: true,
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Datum',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState.fields['datum']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialDate: DateTime.now(),
                      // locale: const Locale.fromSubtags(languageCode: 'nl'),
                      onChanged: (val) {
                        model.datum = val;
                        weekNumber(val);
                      },
                      onSaved: (value){
                        model.datum = value;
                        weekNumber(value);
                      },
                    ),
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'omschrijving',
                      decoration: InputDecoration(
                        labelText: 'omschrijving',
                        suffix: _genderHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                      ),
                      allowClear: true,
                      hint: const Text('Selecteer omschrijving'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: werkomschrijvingen.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['omschrijving']),
                          value: item['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (val) {
                        model.omschrijving = val;
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'begintijd',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      format: DateFormat("HH:mm"),
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'Begintijd',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState.fields['begintijd']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      locale: const Locale.fromSubtags(languageCode: 'nl'),
                      onChanged: (val) {
                        model.begintijd = val;
                      },
                    ),
                    FormBuilderDateTimePicker(
                      name: 'pauze',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'Pauze',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState.fields['pauze']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      locale: const Locale.fromSubtags(languageCode: 'nl'),
                      onChanged: (val) {
                        model.pauze = val;
                      },
                    ),
                    FormBuilderDateTimePicker(
                      name: 'eindtijd',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'Eindtijd',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState.fields['eindtijd']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      locale: const Locale.fromSubtags(languageCode: 'nl'),
                      onChanged: (val) {
                        model.eindtijd = val;
                        getTotaaltijd(model.begintijd, model.eindtijd, model.pauze);
                      },
                    ),
                    FormBuilderDateTimePicker(
                      name: 'totaaltijd',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      enabled: false,
                      initialValue: DateTime.now(),
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'totaaltijd',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState.fields['totaaltijd']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      locale: const Locale.fromSubtags(languageCode: 'nl'),
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
                          postWerkbon(model.weeknummer,
                              model.datum.toString(),
                              model.omschrijving,
                              model.begintijd.toString(),
                              model.pauze.toString(),
                              model.eindtijd.toString(),
                              model.totaaltijd.toString()
                          );
                          // debugPrint(model.toString());
                        } else {
                          // debugPrint(_formKey.currentState?.value.toString());
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
                      // color: Theme.of(context).colorScheme.secondary,
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