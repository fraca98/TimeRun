import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/screens/homePage.dart';
import 'package:timerun/screens/introductionPage.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'bloc/introfitbit_bloc/introfitbit_bloc.dart';
import 'bloc/introwithings_bloc/introwithings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //to perform await/async in main

  SharedPreferences? prefs =
      await SharedPreferences.getInstance(); //import sharedpreferences

  AppDatabase database = AppDatabase(); //inizialize database

  final getIt = GetIt.I;
  getIt.registerSingleton<AppDatabase>(
      database); //pass the database in getIt to access it everywhere (use it cause with no context we can't use provider in BLOC)

  runApp(MyApp(prefs));
}

class MyApp extends StatelessWidget {
  SharedPreferences prefs;

  MyApp(this.prefs, {super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //change the style of the statusBar
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: prefs.getBool('isIntroEnded') == true
          ? HomePage()
          : IntroductionPage(
              prefs: prefs,
            ),
    );
  }
}
