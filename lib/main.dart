import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/providers/datacollectionprovider.dart';
import 'package:timerun/providers/introprovider.dart';
import 'package:timerun/screens/datacollectionpage.dart';
import 'package:timerun/screens/homePage.dart';
import 'package:timerun/screens/introductionPage.dart';
import 'package:timerun/screens/registrationpage.dart';
import 'package:provider/provider.dart';
import 'package:timerun/screens/userPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //to perform await/async in main

  SharedPreferences? prefs =
      await SharedPreferences.getInstance(); //import sharedpreferences
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
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IntroProvider>(
            create: (context) => IntroProvider(prefs)),
        ChangeNotifierProvider<DataCollectionProvider>(
            create: ((context) => DataCollectionProvider())),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: prefs.getBool('isIntroEnded') == true
              ? HomePage.route
              : IntroductionPage.route,
          routes: {
            HomePage.route: (context) => HomePage(),
            DataCollectionPage.route: (context) => DataCollectionPage(),
            RegistrationPage.route: (context) => RegistrationPage(),
            IntroductionPage.route: (context) => IntroductionPage(),
            UserPage.route: (context) => UserPage(),
          }),
    );
  }
}
