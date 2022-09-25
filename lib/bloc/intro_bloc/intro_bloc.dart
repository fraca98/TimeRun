import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:withings_flutter/withings_flutter.dart';

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  IntroBloc(SharedPreferences? prefs)
      : super(prefs?.getString('accessToken') != null
                ? IntroLoaded() //all'inizio carica questo se non ho salvato l'accesToken
                : IntroInitial() //altrimenti carica lo stato dove è stato caricato
            ) {
    on<LoadIntroEvent>((event, emit) async {
      emit(IntroLoading());
      await Future.delayed(Duration(seconds: 1));
      List<String?> authResp;
      authResp = await WithingsConnector.authorize(
          clientID:
              'd49824f2a5059e804fc1da4d639e80d8dea2aeb46429e8e5513008d13af551d4',
          clientSecret:
              'c394dac9319599fa92f275fa6bc283d79e6c0fbea71fce088ba192777370f7ee',
          scope: 'user.activity,user.metrics,user.sleepevents',
          redirectUri: 'example://withings/auth',
          callbackUrlScheme: 'example');
      await Future.delayed(Duration(seconds: 1));
      if (authResp[0] != null && authResp[1] != null) {
        await prefs?.setString('accessToken', authResp[0]!);
        await prefs?.setString('refreshToken', authResp[1]!);
        emit(IntroLoaded());
      } else {
        emit(IntroError());
      }
    });
  }
}
