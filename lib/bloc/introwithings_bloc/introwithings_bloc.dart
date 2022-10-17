import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              'd49824f2a5059e804fc1da4d639e80d8dea2aeb46429e8e5513008d13af551d4',
          clientSecret:
              'c394dac9319599fa92f275fa6bc283d79e6c0fbea71fce088ba192777370f7ee',
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
