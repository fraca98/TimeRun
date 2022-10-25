import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/credentials.dart';
import 'package:timerun/model/device.dart';
import 'package:withings_flutter/withings_flutter.dart';
part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  AppDatabase db = GetIt.I<AppDatabase>();
  SharedPreferences prefs = GetIt.I<SharedPreferences>();
  StreamSubscription? subStreamSession;
  DetailBloc(int id) : super(DetailStateLoading()) {
    Stream<List<Session>> streamSession = db.sessionsDao.watchSessionUser(id);

    subStreamSession = streamSession.listen((event) async {
      if (event.isEmpty) {
        emit(DetailStateLoaded(session1: null, session2: null));
      } else if (event.length == 1) {
        emit(DetailStateLoaded(session1: event[0], session2: null));
      } else if (event.length == 2) {
        emit(DetailStateLoaded(session1: event[0], session2: event[1]));
      } else {}
    });

    on<DetailEventDeleteUser>(
      (event, emit) async {
        emit(DetailStateDeletingUser());
        await db.usersDao
            .deleteUser(id); //on cascade deletes linked Sessions, Intervals
        //print('Removed user');
        emit(DetailStateDeletedUser());
      },
    );

    Future<bool> _withingsDownload(int idSession) async {
      bool error = false;
      List<Interval> interv =
          await db.intervalsDao.getIntervalBySession(idSession);
      print(interv);
      List<List<WithingsRatesCompanion>> withingsToSave =
          List.generate(interv.length, (index) => []);
      try {
        for (int i = 0; i < interv.length; i++) {
          WithingsMeasureGetIntradayactivityData getintradayactivity =
              await WithingsMeasureGetIntradayactivityDataManager()
                  .fetch(WithingsMeasureAPIURL.getIntradayactivity(
            accessToken: prefs.getString('withingsAccessToken')!,
            startdate: interv[i].startstimestamp,
            enddate: interv[i].endtimestamp,
            dataFields: 'heart_rate',
          ));
          if ([101, 102, 200, 401].contains(getintradayactivity.status)) {
            //code for authentication failed
            //refresh accesstoken
            WithingsCredentials? newWithCred =
                await WithingsConnector.refreshToken(
                    clientID: clientWithings[0],
                    clientSecret: clientWithings[1],
                    withingsRefreshToken:
                        prefs.getString('withingsRefreshToken')!);
            if (newWithCred != null) {
              await prefs.setString(
                  'withingsAccessToken', newWithCred.withingsAccessToken);
              await prefs.setString(
                  'withingsRefreshToken', newWithCred.withingsAccessToken);
              getintradayactivity =
                  await WithingsMeasureGetIntradayactivityDataManager()
                      .fetch(WithingsMeasureAPIURL.getIntradayactivity(
                accessToken: prefs.getString('withingsAccessToken')!,
                startdate: interv[i].startstimestamp,
                enddate: interv[i].endtimestamp,
                dataFields: 'heart_rate',
              )); //retry the request with refreshed tokens
            } else {
              error = true;
              print('Error refreshing tokens');
              break;
            }
          }
          if (getintradayactivity.status == 0) {
            if (getintradayactivity.series == null) {
              print('I have no values for this interval');
              error = true;
              break;
            } else {
              getintradayactivity.series!.forEach((element) {
                withingsToSave[i].add(WithingsRatesCompanion(
                    idInterval: Value(interv[i].id),
                    timestamp: Value(element.timestamp!),
                    value: Value(element.heartRate!)));
              });
            }
          } else {
            error = true;
            break;
          }
        }
      } catch (e) {
        print(e);
        error = true;
      }
      if (error == false) {
        withingsToSave.forEach((element) {
          element.forEach((element) async {
            await db.withingsRatesDao.insert(WithingsRatesCompanion(
                idInterval: element.idInterval,
                timestamp: element.timestamp,
                value: element.value));
          });
        });
      }
      return error; //error = true or error = false
    }

    _fitbitDownload() {}

    on<DetailEventDownload>(
      (event, emit) async {
        print('Pressed download');
        emit(DetailStateDownloading(
            session1: (state as DetailStateLoaded).session1,
            session2: (state as DetailStateLoaded).session2,
            downSession: event.numSession));

        bool error = false;

        if (event.numSession == 1) {
          if (error == false &&
                  (state as DetailStateDownloading).session1!.device1 ==
                      devices[0] ||
              (state as DetailStateDownloading).session1!.device2 ==
                  devices[0]) {
            error = true;
          } //Fitbit
          if (error == false &&
                  (state as DetailStateDownloading).session1!.device1 ==
                      devices[1] ||
              (state as DetailStateDownloading).session1!.device2 ==
                  devices[1]) {
            error = await _withingsDownload(
                (state as DetailStateDownloading).session1!.id);
          } //Withings

        } else {
          if (error == false &&
                  (state as DetailStateDownloading).session2!.device1 ==
                      devices[0] ||
              (state as DetailStateDownloading).session2!.device2 ==
                  devices[0]) {
            error = true;
          } //Fitbit
          if (error == false &&
                  (state as DetailStateDownloading).session2!.device1 ==
                      devices[1] ||
              (state as DetailStateDownloading).session2!.device2 ==
                  devices[1]) {
            error = await _withingsDownload(
                (state as DetailStateDownloading).session2!.id);
          } //Withings
        }

        if (error == false) {
          //if no error update session as downloaded
          event.numSession == 1
              ? await db.sessionsDao.updateDown(
                  (state as DetailStateDownloading).session1!.id, true)
              : await db.sessionsDao.updateDown(
                  (state as DetailStateDownloading).session2!.id, true);
        }
        emit(DetailStateLoaded(
            session1: (state as DetailStateDownloading).session1,
            session2: (state as DetailStateDownloading).session2,
            error: error)); //error = true or error = false
      },
    );
  }
  @override
  Future<void> close() {
    subStreamSession?.cancel();
    return super.close();
  }
}
