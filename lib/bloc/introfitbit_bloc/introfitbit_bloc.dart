import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/model/credentials.dart';

part 'introfitbit_event.dart';
part 'introfitbit_state.dart';

class IntroFitbitBloc extends Bloc<IntroFitbitEvent, IntroFitbitState> {
  IntroFitbitBloc(SharedPreferences? prefs)
      : super(prefs?.getString('fitbitAccessToken') != null
                ? IntroFitbitLoaded() //load this if i have not the accessToken of Fitbit
                : IntroFitbitInitial() //else load this
            ) {
    on<LoadIntroFitbitEvent>((event, emit) async {
      emit(IntroFitbitLoading());
      FitbitCredentials? fitbitCredentials = await FitbitConnector.authorize(
          clientID: clientFitbit[0],
          clientSecret: clientFitbit[1],
          redirectUri: clientFitbit[2],
          callbackUrlScheme: 'timerun');
      if (fitbitCredentials != null) {
        await prefs?.setString('fitbitUserID', fitbitCredentials.userID);
        await prefs?.setString('fitbitAccessToken',
            fitbitCredentials.fitbitAccessToken);
        await prefs?.setString('fitbitRefreshToken',
            fitbitCredentials.fitbitRefreshToken);
        emit(IntroFitbitLoaded());
      } else {
        emit(IntroFitbitError());
      }
    });
  }
}
