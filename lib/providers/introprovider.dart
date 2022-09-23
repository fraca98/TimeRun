import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:withings_flutter/withings_flutter.dart';

class IntroProvider extends ChangeNotifier {
  bool isIntroEnded = false; //variabile che mi serve per capire se è necessario andare direttamente alla homepage
  bool isLoading = false; //per mostrare caricamento

  String? accessToken; //accessToken for Withings
  String? refreshToken; //refreshToken for Withings

  SharedPreferences? prefs;
  IntroProvider(this.prefs) {
    accessToken = prefs?.getString('accessToken');
    refreshToken = prefs?.getString('refreshToken');
    isIntroEnded = prefs?.getBool('isIntroEnded') ?? false;
  }

  Future<void> withAuthorization() async {
    List<String?> authResp;
    try {
      authResp = await WithingsConnector.authorize(
          clientID:
              'd49824f2a5059e804fc1da4d639e80d8dea2aeb46429e8e5513008d13af551d4',
          clientSecret:
              'c394dac9319599fa92f275fa6bc283d79e6c0fbea71fce088ba192777370f7ee',
          scope: 'user.activity,user.metrics,user.sleepevents',
          redirectUri: 'example://withings/auth',
          callbackUrlScheme: 'example');
      accessToken = authResp[0];
      refreshToken = authResp[1];

      await prefs?.setString('accessToken', accessToken!);
      await prefs?.setString('refreshToken', refreshToken!);
    } catch (e) {}
  }

  void updateLoading() {
    //UI del pulsante o indicatore di caricamento
    isLoading = !isLoading;
    notifyListeners();
  }

  void introEnded() async {
    isIntroEnded = true;
    await prefs?.setBool('isIntroEnded', isIntroEnded);
  }
}
