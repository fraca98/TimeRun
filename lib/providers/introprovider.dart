import 'package:shared_preferences/shared_preferences.dart';

class IntroProvider {
  //senza changeNotifier perchè non mi interessa notifylistener(), ma solo accedere alla classe
  bool isIntroEnded =
      false; //variabile che mi serve per capire se è necessario andare direttamente alla homepage

  SharedPreferences? prefs;
  IntroProvider(this.prefs) {
    isIntroEnded = prefs?.getBool('isIntroEnded') ?? false;
  }
  void introEnded() async {
    isIntroEnded = true;
    await prefs?.setBool('isIntroEnded', isIntroEnded);
  }
}
