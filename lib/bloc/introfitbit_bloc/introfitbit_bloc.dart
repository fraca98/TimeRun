import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'introfitbit_event.dart';
part 'introfitbit_state.dart';

class IntroFitbitBloc extends Bloc<IntroFitbitEvent, IntroFitbitState> {
  IntroFitbitBloc(SharedPreferences? prefs)
      : super(prefs?.getString('fitbitAccessToken') != null
                ? IntroFitbitLoaded() //all'inizio carica questo se non ho salvato l'accesToken
                : IntroFitbitInitial() //altrimenti carica lo stato dove è stato caricato
            ) {
    on<LoadIntroFitbitEvent>((event, emit) async {
      emit(IntroFitbitLoading());
      FitbitCredentials? fitbitCredentials = await FitbitConnector.authorize(
          clientID: '238CG7',
          clientSecret: '6814538ffe2fa5708f85373a80bc2d4e',
          redirectUri: 'example://fitbit/auth',
          callbackUrlScheme: 'example');
      if (fitbitCredentials != null) {
        await prefs?.setString('fitbitUserID', fitbitCredentials.userID);
        await prefs?.setString('fitbitCredentialsAccessToken',
            fitbitCredentials.fitbitAccessToken);
        await prefs?.setString('fitbitCredentialsRefreshToken',
            fitbitCredentials.fitbitRefreshToken);
        emit(IntroFitbitLoaded());
      } else {
        emit(IntroFitbitError());
      }
    });
  }
}
