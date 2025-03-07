import 'package:attandence_tracker/ui/components/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home/home_screen.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({super.key});

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  // Times
  String strAddress = '', strDate = '', strTime = '', strDateTime = '';
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;

  // TextControllers
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerFrom = TextEditingController();
  final TextEditingController controllerTo = TextEditingController();

  // Firestore Collection
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('absent');

  // Dropdown Settings
  String dropdownValue = 'Please Choose';
  List<String> categoriesList = [
    'Please Choose',
    'Permission',
    'Sick',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Permission Request Menu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.deepOrange,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.maps_home_work_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Please fill out the Form!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    labelText: 'Your name',
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.deepOrange,
                    ),
                    hintText: 'Enter your Name',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.deepOrange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Excuse',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.deepOrange,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 4,
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.deepOrange,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 14,
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    items: categoriesList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.deepOrange,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'From: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2050),
                                  builder: (BuildContext context,
                                          Widget? child) =>
                                      Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                    onPrimary: Colors.white,
                                                    onSurface:
                                                        Colors.deepOrange,
                                                    primary: Colors.deepOrange),
                                            datePickerTheme:
                                                const DatePickerThemeData(
                                              headerBackgroundColor:
                                                  Colors.deepOrange,
                                              backgroundColor: Colors.white,
                                              headerForegroundColor:
                                                  Colors.white,
                                              surfaceTintColor: Colors.white,
                                            ),
                                          ),
                                          child: child!),
                                );
                                if (pickedDate != null) {
                                  controllerFrom.text =
                                      DateFormat("dd/MM/yy").format(pickedDate);
                                }
                              },
                              controller: controllerFrom,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Starting From',
                                hintStyle: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'To: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2050),
                                  builder: (BuildContext context,
                                          Widget? child) =>
                                      Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                    onPrimary: Colors.white,
                                                    onSurface:
                                                        Colors.deepOrange,
                                                    primary: Colors.deepOrange),
                                            datePickerTheme:
                                                const DatePickerThemeData(
                                              headerBackgroundColor:
                                                  Colors.deepOrange,
                                              backgroundColor: Colors.white,
                                              headerForegroundColor:
                                                  Colors.white,
                                              surfaceTintColor: Colors.white,
                                            ),
                                          ),
                                          child: child!),
                                );
                                if (pickedDate != null) {
                                  controllerTo.text =
                                      DateFormat("dd/MM/yy").format(pickedDate);
                                }
                              },
                              controller: controllerTo,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Until From',
                                hintStyle: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange,
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (controllerName.text.isEmpty ||
                              controllerFrom.text.isEmpty ||
                              controllerTo.text.isEmpty ||
                              dropdownValue == 'Please Choose') {
                            return customSnackbar(
                              context,
                              Icons.info_outline,
                              'Please fill the form correctly!',
                            );
                          } else {
                            submitAbsent(
                              controllerName.text,
                              dropdownValue,
                              controllerFrom.text,
                              controllerTo.text,
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Report Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitAbsent(
      String name, String excuse, String from, String until) async {
    showLoaderDialog(context);

    await dataCollection.add({
      'name': name,
      'status': excuse,
      'dateTime': '$from-$until',
    }).then((result) {
      Navigator.pop(context);
      try {
        customSnackbar(
          context,
          Icons.check_circle_outline,
          'Yeay! Permission report succeed!',
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } catch (e) {
        customSnackbar(context, Icons.error_outline, 'Error: $e');
      }
    }).catchError((onError) {
      customSnackbar(context, Icons.error_outline, 'Error: $onError');
      Navigator.pop(context);
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
          ),
          SizedBox(width: 10),
          Text('Checking Data'),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
