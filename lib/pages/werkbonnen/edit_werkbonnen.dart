import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_backend/pages/werkbonnen/werkbonnen_page.dart';
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
      home: EditWerkbonnenPage(),
    );
  }
}

class EditWerkbonnenPage extends StatefulWidget {
  final Werkbon werkbonnen;
  final WerkomschrijvingData werkomschrijvingen;
  final int index;

  EditWerkbonnenPage({Key key, this.werkbonnen, this.werkomschrijvingen, this.index}) : super(key: key);

  @override
  _EditWerkbonnenPageState createState() => _EditWerkbonnenPageState();
}

class _EditWerkbonnenPageState extends State<EditWerkbonnenPage> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  var userInfo = '';
  // bool _ageHasError = false;
  bool _genderHasError = false;
  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }
  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
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
        debugPrint(userInfo);
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

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('nl_NL', null);
    final dateStr = DateFormat('yyyy-MM-dd').format(this.widget.werkbonnen.datum);
    DateFormat inputFormat = DateFormat('hh:mm:ss');

    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Wijzig werkbon"),
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
            children: [
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
                        onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WerkbonnenPage()))),
                  ],
                ),
              ),
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState.save();
                  debugPrint(_formKey.currentState.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {
                  'movie_rating': 5,
                  'best_language': 'Dart',
                  'age': '13',
                  'gender': 'Male',
                  'languages_filter': ['Dart']
                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      name: 'datum',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.tryParse(dateStr),
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
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      locale: const Locale.fromSubtags(languageCode: 'nl'),
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
                      initialValue: this.widget.werkbonnen.werkomschrijving.id.toString(),
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
                        setState(() {
                          _genderHasError = !(_formKey
                              .currentState?.fields['omschrijving']
                              ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'begintijd',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: inputFormat.parse(this.widget.werkbonnen.begintijd),
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
                    ),
                    FormBuilderDateTimePicker(
                      name: 'pauze',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: inputFormat.parse(this.widget.werkbonnen.pauze),
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
                    ),
                    FormBuilderDateTimePicker(
                      name: 'eindtijd',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: inputFormat.parse(this.widget.werkbonnen.eindtijd),
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
                    ),
                    FormBuilderDateTimePicker(
                      name: 'totaaltijd',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      enabled: false,
                      initialValue: inputFormat.parse(this.widget.werkbonnen.totaaltijdDag),
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
                    // FormBuilderDateRangePicker(
                    //   name: 'date_range',
                    //   firstDate: DateTime(0, 0, 0, 1, 1),
                    //   lastDate: DateTime(2030),
                    //   format: DateFormat('HH-mm'),
                    //   onChanged: _onChanged,
                    //   decoration: InputDecoration(
                    //     labelText: 'Date Range',
                    //     helperText: 'Helper text',
                    //     hintText: 'Hint text',
                    //     suffixIcon: IconButton(
                    //       icon: const Icon(Icons.close),
                    //       onPressed: () {
                    //         _formKey.currentState.fields['date_range']
                    //             ?.didChange(null);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // FormBuilderSlider(
                    //   name: 'slider',
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.min(6),
                    //   ]),
                    //   onChanged: _onChanged,
                    //   min: 0.0,
                    //   max: 10.0,
                    //   initialValue: 7.0,
                    //   divisions: 20,
                    //   activeColor: Colors.red,
                    //   inactiveColor: Colors.pink[100],
                    //   decoration: const InputDecoration(
                    //     labelText: 'Number of things',
                    //   ),
                    // ),
                    // FormBuilderRangeSlider(
                    //   name: 'range_slider',
                    //   // validator: FormBuilderValidators.compose([FormBuilderValidators.min(context, 6)]),
                    //   onChanged: _onChanged,
                    //   min: 00.00,
                    //   max: 23.59,
                    //   initialValue: const RangeValues(08.00, 16.00),
                    //   divisions: 20,
                    //   activeColor: Colors.red,
                    //   inactiveColor: Colors.pink[100],
                    //   decoration:
                    //   const InputDecoration(labelText: 'Price Range'),
                    // ),
                    // FormBuilderCheckbox(
                    //   name: 'accept_terms',
                    //   initialValue: false,
                    //   onChanged: _onChanged,
                    //   title: RichText(
                    //     text: const TextSpan(
                    //       children: [
                    //         TextSpan(
                    //           text: 'I have read and agree to the ',
                    //           style: TextStyle(color: Colors.black),
                    //         ),
                    //         TextSpan(
                    //           text: 'Terms and Conditions',
                    //           style: TextStyle(color: Colors.blue),
                    //           // Flutter doesn't allow a button inside a button
                    //           // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086
                    //           /*
                    //           recognizer: TapGestureRecognizer()
                    //             ..onTap = () {
                    //               print('launch url');
                    //             },
                    //           */
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   validator: FormBuilderValidators.equal(
                    //     true,
                    //     errorText:
                    //     'You must accept terms and conditions to continue',
                    //   ),
                    // ),
                    // FormBuilderTextField(
                    //   autovalidateMode: AutovalidateMode.always,
                    //   name: 'age',
                    //   decoration: InputDecoration(
                    //     labelText: 'Age',
                    //     suffixIcon: _ageHasError
                    //         ? const Icon(Icons.error, color: Colors.red)
                    //         : const Icon(Icons.check, color: Colors.green),
                    //   ),
                    //   onChanged: (val) {
                    //     setState(() {
                    //       _ageHasError = !(_formKey.currentState?.fields['age']
                    //           ?.validate() ??
                    //           false);
                    //     });
                    //   },
                    //   // valueTransformer: (text) => num.tryParse(text),
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(),
                    //     FormBuilderValidators.max(120),
                    //   ]),
                    //   // initialValue: '12',
                    //   keyboardType: TextInputType.text,
                    //   textInputAction: TextInputAction.next,
                    // ),
                    // FormBuilderRadioGroup<String>(
                    //   decoration: const InputDecoration(
                    //     labelText: 'My chosen language',
                    //   ),
                    //   initialValue: null,
                    //   name: 'best_language',
                    //   onChanged: _onChanged,
                    //   validator: FormBuilderValidators.compose(
                    //       [FormBuilderValidators.required()]),
                    //   options:
                    //   ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
                    //       .map((lang) => FormBuilderFieldOption(
                    //     value: lang,
                    //     child: Text(lang),
                    //   ))
                    //       .toList(growable: false),
                    //   controlAffinity: ControlAffinity.trailing,
                    // ),
                    // FormBuilderSegmentedControl(
                    //   decoration: const InputDecoration(
                    //     labelText: 'Movie Rating (Archer)',
                    //   ),
                    //   name: 'movie_rating',
                    //   // initialValue: 1,
                    //   // textStyle: TextStyle(fontWeight: FontWeight.bold),
                    //   options: List.generate(5, (i) => i + 1)
                    //       .map((number) => FormBuilderFieldOption(
                    //     value: number,
                    //     child: Text(
                    //       number.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ))
                    //       .toList(),
                    //   onChanged: _onChanged,
                    // ),
                    // FormBuilderSwitch(
                    //   title: const Text('I Accept the terms and conditions'),
                    //   name: 'accept_terms_switch',
                    //   initialValue: true,
                    //   onChanged: _onChanged,
                    // ),
                    // FormBuilderCheckboxGroup<String>(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   decoration: const InputDecoration(
                    //       labelText: 'The language of my people'),
                    //   name: 'languages',
                    //   // initialValue: const ['Dart'],
                    //   options: const [
                    //     FormBuilderFieldOption(value: 'Dart'),
                    //     FormBuilderFieldOption(value: 'Kotlin'),
                    //     FormBuilderFieldOption(value: 'Java'),
                    //     FormBuilderFieldOption(value: 'Swift'),
                    //     FormBuilderFieldOption(value: 'Objective-C'),
                    //   ],
                    //   onChanged: _onChanged,
                    //   separator: const VerticalDivider(
                    //     width: 10,
                    //     thickness: 5,
                    //     color: Colors.red,
                    //   ),
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.minLength(1),
                    //     FormBuilderValidators.maxLength(3),
                    //   ]),
                    // ),
                    // FormBuilderFilterChip<String>(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   decoration: const InputDecoration(
                    //       labelText: 'The language of my people'),
                    //   name: 'languages_filter',
                    //   selectedColor: Colors.red,
                    //   options: const [
                    //     FormBuilderChipOption(
                    //       value: 'Dart',
                    //       avatar: CircleAvatar(child: Text('D')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Kotlin',
                    //       avatar: CircleAvatar(child: Text('K')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Java',
                    //       avatar: CircleAvatar(child: Text('J')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Swift',
                    //       avatar: CircleAvatar(child: Text('S')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Objective-C',
                    //       avatar: CircleAvatar(child: Text('O')),
                    //     ),
                    //   ],
                    //   onChanged: _onChanged,
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.minLength(1),
                    //     FormBuilderValidators.maxLength(3),
                    //   ]),
                    // ),
                    // FormBuilderChoiceChip<String>(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   decoration: const InputDecoration(
                    //       labelText:
                    //       'Ok, if I had to choose one language, it would be:'),
                    //   name: 'languages_choice',
                    //   initialValue: 'Dart',
                    //   options: const [
                    //     FormBuilderChipOption(
                    //       value: 'Dart',
                    //       avatar: CircleAvatar(child: Text('D')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Kotlin',
                    //       avatar: CircleAvatar(child: Text('K')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Java',
                    //       avatar: CircleAvatar(child: Text('J')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Swift',
                    //       avatar: CircleAvatar(child: Text('S')),
                    //     ),
                    //     FormBuilderChipOption(
                    //       value: 'Objective-C',
                    //       avatar: CircleAvatar(child: Text('O')),
                    //     ),
                    //   ],
                    //   onChanged: _onChanged,
                    // ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
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