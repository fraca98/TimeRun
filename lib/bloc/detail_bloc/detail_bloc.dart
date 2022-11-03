import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:fitbitter/fitbitter.dart';
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

    Future<List<List<WithingsRatesCompanion>>?> _withingsDownload(
        int idSession) async {
      bool error = false;
      List<Interval> interv =
          await db.intervalsDao.getIntervalBySession(idSession);
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
                  'withingsRefreshToken', newWithCred.withingsRefreshToken);
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

      if (error == true) {
        return null;
      } else {
        return withingsToSave;
      }
    }

    Future<List<List<FitbitRatesCompanion>>?> _fitbitDownload(
        int idSession) async {
      bool error = false;
      List<Interval> interv =
          await db.intervalsDao.getIntervalBySession(idSession);
      List<List<FitbitRatesCompanion>> fitbitToSave =
          List.generate(interv.length, (index) => []);
      try {
        for (int i = 0; i < interv.length; i++) {
          bool valid = await FitbitConnector.isTokenValid(
            fitbitCredentials: FitbitCredentials(
                //check if token still valid
                userID: prefs.getString('fitbitUserID')!,
                fitbitAccessToken: prefs.getString('fitbitAccessToken')!,
                fitbitRefreshToken: prefs.getString('fitbitRefreshToken')!),
          );
          if (valid == false) {
            FitbitCredentials newFitbitCredentials =
                await FitbitConnector.refreshToken(
              clientID: clientFitbit[0],
              clientSecret: clientFitbit[1],
              fitbitCredentials: FitbitCredentials(
                  userID: prefs.getString('fitbitUserID')!,
                  fitbitAccessToken: prefs.getString('fitbitAccessToken')!,
                  fitbitRefreshToken: prefs.getString('fitbitRefreshToken')!),
            );
            await prefs.setString(
                'fitbitAccessToken', newFitbitCredentials.fitbitAccessToken);
            await prefs.setString(
                'fitbitRefreshToken', newFitbitCredentials.fitbitRefreshToken);
          }
          List<FitbitHeartRateIntradayData> fitbitHeartRateIntradayData =
              await FitbitHeartRateIntradayDataManager(
                      clientID: clientFitbit[0], clientSecret: clientFitbit[1])
                  .fetch(
            FitbitHeartRateIntradayAPIURL.dateRangeAndDetailLevel(
                fitbitCredentials: FitbitCredentials(
                    userID: prefs.getString('fitbitUserID')!,
                    fitbitAccessToken: prefs.getString('fitbitAccessToken')!,
                    fitbitRefreshToken: prefs.getString('fitbitRefreshToken')!),
                startDate: DateTime.fromMillisecondsSinceEpoch(
                    interv[i].startstimestamp * 1000),
                endDate: DateTime.fromMillisecondsSinceEpoch(
                    interv[i].endtimestamp * 1000),
                intradayDetailLevel: IntradayDetailLevel.ONE_SECOND),
          ) as List<FitbitHeartRateIntradayData>;
          print(fitbitHeartRateIntradayData);

          if (fitbitHeartRateIntradayData.isEmpty) {
            print('No data for this interval');
            error = true;
            break;
          } else {
            fitbitHeartRateIntradayData.forEach((element) {
              fitbitToSave[i].add(FitbitRatesCompanion(
                idInterval: Value(interv[i].id),
                timestamp: Value(
                    (element.dateOfMonitoring!.toUtc().millisecondsSinceEpoch /
                            1000)
                        .floor()),
                value: Value(element.value!.toInt()),
              ));
            });
          }
        }
      } catch (e) {
        print(e);
        error = true;
      }

      if (error == true) {
        return null;
      } else {
        return fitbitToSave;
      }
    }

    on<DetailEventDownload>((event, emit) async {
      print('Pressed download');
      emit(DetailStateDownloading(
          session1: (state as DetailStateLoaded).session1,
          session2: (state as DetailStateLoaded).session2,
          downSession: event.numSession));

      bool error = false;
      var fitbitToSave;
      var withingsToSave;

      if (event.numSession == 1) {
        if (error == false &&
            ((state as DetailStateDownloading).session1!.device1 ==
                    devices[0] ||
                (state as DetailStateDownloading).session1!.device2 ==
                    devices[0])) {
          var fitbitToSave = await _fitbitDownload(
              (state as DetailStateDownloading).session1!.id);
          fitbitToSave != null ? error = false : error = true;
          //print('1f');
        } //Fitbit
        if (error == false &&
            ((state as DetailStateDownloading).session1!.device1 ==
                    devices[1] ||
                (state as DetailStateDownloading).session1!.device2 ==
                    devices[1])) {
          var withingsToSave = await _withingsDownload(
              (state as DetailStateDownloading).session1!.id);
          withingsToSave != null ? error = false : error = true;
          //print('1w');
        } //Withings

      } else {
        if (error == false &&
            ((state as DetailStateDownloading).session2!.device1 ==
                    devices[0] ||
                (state as DetailStateDownloading).session2!.device2 ==
                    devices[0])) {
          var fitbitToSave = await _fitbitDownload(
              (state as DetailStateDownloading).session2!.id);
          fitbitToSave != null ? error = false : error = true;
          //print('2f');
        } //Fitbit
        if (error == false &&
            ((state as DetailStateDownloading).session2!.device1 ==
                    devices[1] ||
                (state as DetailStateDownloading).session2!.device2 ==
                    devices[1])) {
          var withingsToSave = await _withingsDownload(
              (state as DetailStateDownloading).session2!.id);
          withingsToSave != null ? error = false : error = true;
          //print('2w');
        } //Withings
      }

      if (error == false) {
        fitbitToSave?.forEach((element) {
          element.forEach((element) async {
            await db.fitbitRatesDao.insert(FitbitRatesCompanion(
                idInterval: element.idInterval,
                timestamp: element.timestamp,
                value: element.value));
          });
        });

        withingsToSave?.forEach((element) {
          element.forEach((element) async {
            await db.withingsRatesDao.insert(WithingsRatesCompanion(
                idInterval: element.idInterval,
                timestamp: element.timestamp,
                value: element.value));
          });
        });

        //if no error update session as downloaded
        event.numSession == 1
            ? await db.sessionsDao.updateDown(
                (state as DetailStateDownloading).session1!.id, true)
            : await db.sessionsDao.updateDown(
                (state as DetailStateDownloading).session2!.id, true);
        //listen will emit the state once completed and updated this if error = false
      } else {
        //if error == true i need to emit the state with the error
        emit(DetailStateLoaded(
            session1: (state as DetailStateDownloading).session1,
            session2: (state as DetailStateDownloading).session2,
            error: true));
      }
    });
  }
  @override
  Future<void> close() async {
    await subStreamSession?.cancel();
    return super.close();
  }
}
