import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/model/credentials.dart';
import 'package:withings_flutter/withings_flutter.dart';

part 'introwithings_event.dart';
part 'introwithings_state.dart';

class IntroWithingsBloc extends Bloc<IntroWithingsEvent, IntroWithingsState> {
  IntroWithingsBloc(SharedPreferences? prefs)
      : super(prefs?.getString('withingsAccessToken') != null
                ? IntroWithingsLoaded() //all'inizio carica questo se non ho salvato l'accesToken
                : IntroWithingsInitial() //altrimenti carica lo stato dove è stato caricato
            ) {
    on<LoadIntroWithingsEvent>((event, emit) async {
      emit(IntroWithingsLoading());
      WithingsCredentials? withingsCredentials;
      withingsCredentials = await WithingsConnector.authorize(
          clientID:
              clientWithings[0],
          clientSecret:
              clientWithings[1],
          scope: 'user.activity,user.metrics,user.sleepevents',
          redirectUri: 'example://withings/auth',
          callbackUrlScheme: 'example');
      if (withingsCredentials != null) {
        await prefs?.setString('withingsUserID', withingsCredentials.userID);
        await prefs?.setString(
            'withingsAccessToken', withingsCredentials.withingsAccessToken);
        await prefs?.setString(
            'withingsRefreshToken', withingsCredentials.withingsRefreshToken);
        emit(IntroWithingsLoaded());
      } else {
        emit(IntroWithingsError());
      }
    });
  }
}
