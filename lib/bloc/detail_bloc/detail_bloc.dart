import 'dart:async';
import 'dart:io';
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
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  AppDatabase db = GetIt.I<AppDatabase>();
  SharedPreferences prefs = GetIt.I<SharedPreferences>();
  StreamSubscription? subStreamSession;
  DetailBloc(User user) : super(DetailStateLoading()) {
    Stream<List<Session>> streamSession =
        db.sessionsDao.watchSessionUser(user.id);

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
        await db.usersDao.deleteUser(
            user.id); //on cascade deletes linked Sessions, Intervals
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
        WithingsMeasureGetIntradayactivityData getWithingsSession =
            await WithingsMeasureGetIntradayactivityDataManager()
                .fetch(WithingsMeasureAPIURL.getIntradayactivity(
          accessToken: prefs.getString('withingsAccessToken')!,
          startdate: interv[0].startstimestamp,
          enddate: interv[interv.length - 1].endtimestamp,
          dataFields: 'heart_rate',
        ));
        if ([101, 102, 200, 401].contains(getWithingsSession.status)) {
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
            getWithingsSession =
                await WithingsMeasureGetIntradayactivityDataManager()
                    .fetch(WithingsMeasureAPIURL.getIntradayactivity(
              accessToken: prefs.getString('withingsAccessToken')!,
              startdate: interv[0].startstimestamp,
              enddate: interv[interv.length - 1].endtimestamp,
              dataFields: 'heart_rate',
            )); //retry the request with refreshed tokens
          } else {
            error = true;
            print('Error refreshing tokens');
          }
        }
        if (getWithingsSession.status == 0) {
          if (getWithingsSession.series == null) {
            print('I have no values for this session');
            error = true;
          } else {
            for (int i = 0; i < interv.length; i++) {
              var intToSave = getWithingsSession.series!.where((element) =>
                  element.timestamp! >= interv[i].startstimestamp &&
                  element.timestamp! <= interv[i].endtimestamp);
              intToSave.forEach((element) {
                withingsToSave[i].add(WithingsRatesCompanion(
                    idInterval: Value(interv[i].id),
                    timestamp: Value(element.timestamp!),
                    value: Value(element.heartRate!)));
              });
            }
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
        List<FitbitHeartRateIntradayData> getFitbitSession =
            await FitbitHeartRateIntradayDataManager(
                    clientID: clientFitbit[0], clientSecret: clientFitbit[1])
                .fetch(
          FitbitHeartRateIntradayAPIURL.dateRangeAndDetailLevel(
              fitbitCredentials: FitbitCredentials(
                  userID: prefs.getString('fitbitUserID')!,
                  fitbitAccessToken: prefs.getString('fitbitAccessToken')!,
                  fitbitRefreshToken: prefs.getString('fitbitRefreshToken')!),
              startDate: DateTime.fromMillisecondsSinceEpoch(
                  interv[0].startstimestamp * 1000),
              endDate: DateTime.fromMillisecondsSinceEpoch(
                  interv[interv.length - 1].endtimestamp * 1000),
              intradayDetailLevel: IntradayDetailLevel.ONE_SECOND),
        ) as List<FitbitHeartRateIntradayData>;
        if (getFitbitSession.isEmpty) {
          print('No data for this session');
          error = true;
        } else {
          for (int i = 0; i < interv.length; i++) {
            var intToSave = getFitbitSession.where((element) =>
                (element.dateOfMonitoring!.toUtc().millisecondsSinceEpoch /
                            1000)
                        .floor() >=
                    interv[i].startstimestamp &&
                (element.dateOfMonitoring!.toUtc().millisecondsSinceEpoch /
                            1000)
                        .floor() <=
                    interv[i].endtimestamp);
            intToSave.forEach((element) {
              fitbitToSave[i].add(
                FitbitRatesCompanion(
                  idInterval: Value(interv[i].id),
                  timestamp: Value((element.dateOfMonitoring!
                              .toUtc()
                              .millisecondsSinceEpoch /
                          1000)
                      .floor()),
                  value: Value(element.value!.toInt()),
                ),
              );
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
          fitbitToSave = await _fitbitDownload(
              (state as DetailStateDownloading).session1!.id);
          fitbitToSave != null ? error = false : error = true;
          //print('1f');
        } //Fitbit
        if (error == false &&
            ((state as DetailStateDownloading).session1!.device1 ==
                    devices[1] ||
                (state as DetailStateDownloading).session1!.device2 ==
                    devices[1])) {
          withingsToSave = await _withingsDownload(
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
          fitbitToSave = await _fitbitDownload(
              (state as DetailStateDownloading).session2!.id);
          fitbitToSave != null ? error = false : error = true;
          //print('2f');
        } //Fitbit
        if (error == false &&
            ((state as DetailStateDownloading).session2!.device1 ==
                    devices[1] ||
                (state as DetailStateDownloading).session2!.device2 ==
                    devices[1])) {
          withingsToSave = await _withingsDownload(
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

    on<DetailEventExport>(
      (event, emit) async {
        print('export ${event.numSession}');
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        } else {
          // User csv
          List<dynamic> headerUser = ['ID', 'Sex', 'Activity'];
          List<List<dynamic>> rowsUser = [];
          rowsUser.add(headerUser);
          rowsUser.add([user.id, user.sex, user.activity]);
          String Usercsv = ListToCsvConverter().convert(rowsUser);
          final path =
              (await Directory('/storage/emulated/0/TimeRun/${user.id}')
                      .create(recursive: true))
                  .path;
          final fileUser = File('$path/user_${user.id}.csv');
          await fileUser.writeAsString(Usercsv);

          int idSession;
          event.numSession == 1
              ? idSession = (state as DetailStateLoaded).session1!.id
              : idSession = (state as DetailStateLoaded).session2!.id;
          final Spath = (await Directory(
                      '/storage/emulated/0/TimeRun/${user.id}/session${idSession}')
                  .create(recursive: true))
              .path;

          // Session csv
          List<List<dynamic>> rowsSession = [];
          rowsSession.add([
            'id',
            'iduser',
            'numsession',
            'startsession',
            'endsession',
            'device1',
            'device2'
          ]);
          if (event.numSession == 1) {
            rowsSession.add([
              (state as DetailStateLoaded).session1!.id,
              (state as DetailStateLoaded).session1!.iduser,
              (state as DetailStateLoaded).session1!.numsession,
              (state as DetailStateLoaded).session1!.startsession,
              (state as DetailStateLoaded).session1!.endsession,
              (state as DetailStateLoaded).session1!.device1,
              (state as DetailStateLoaded).session1!.device2
            ]);
          } else {
            rowsSession.add([
              (state as DetailStateLoaded).session2!.id,
              (state as DetailStateLoaded).session2!.iduser,
              (state as DetailStateLoaded).session2!.numsession,
              (state as DetailStateLoaded).session2!.startsession,
              (state as DetailStateLoaded).session2!.endsession,
              (state as DetailStateLoaded).session2!.device1,
              (state as DetailStateLoaded).session2!.device2
            ]);
          }
          String Sessioncsv = ListToCsvConverter().convert(rowsSession);
          final fileSession =
              File('$Spath/session_${user.id}_${idSession}.csv');
          fileSession.writeAsString(Sessioncsv);

          // Intervals csv
          List<Interval> intervals =
              await db.intervalsDao.getIntervalBySession(idSession);
          List<List<dynamic>> rowsIntervals = [];
          rowsIntervals.add([
            'id',
            'idSession',
            'runstatus',
            'startimesamp',
            'endtimestamp',
            'deltatime'
          ]);
          intervals.forEach((element) {
            rowsIntervals.add([
              element.id,
              element.idSession,
              element.runstatus,
              element.startstimestamp,
              element.endtimestamp,
              element.deltatime
            ]);
          });
          String Intervalcsv = ListToCsvConverter().convert(rowsIntervals);
          final fileInterval =
              File('$Spath/intervals_${user.id}_${idSession}.csv');
          fileInterval.writeAsString(Intervalcsv);

          // Polar csv
          List<dynamic> headerPolar = ['idInterval', 'timestamp', 'value'];
          List<List<dynamic>> rowsPolar = [];
          rowsPolar.add(headerPolar);
          for (int i = 0; i < intervals.length; i++) {
            List<PolarRate> polarSingleInterval =
                await db.polarRatesDao.polarByInterval(intervals[i].id);
            polarSingleInterval.forEach((element) {
              rowsPolar
                  .add([element.idInterval, element.timestamp, element.value]);
            });
          }
          String Polarcsv = ListToCsvConverter().convert(rowsPolar);
          final filePolar = File('$Spath/polar_${user.id}_${idSession}.csv');
          filePolar.writeAsString(Polarcsv);

          Session session;
          event.numSession == 1
              ? session = (state as DetailStateLoaded).session1!
              : session = (state as DetailStateLoaded).session2!;
          if (session.device1 == devices[0] || session.device2 == devices[0]) {
            //fitbit
            List<dynamic> headerFitbit = ['idInterval', 'timestamp', 'value'];
            List<List<dynamic>> rowsFitbit = [];
            rowsFitbit.add(headerFitbit);
            for (int i = 0; i < intervals.length; i++) {
              List<FitbitRate> fitbitSingleInterval =
                  await db.fitbitRatesDao.fitbitByInterval(intervals[i].id);
              fitbitSingleInterval.forEach((element) {
                rowsFitbit.add(
                    [element.idInterval, element.timestamp, element.value]);
              });
            }
            String Fitbitcsv = ListToCsvConverter().convert(rowsFitbit);
            final fileFitbit =
                File('$Spath/fitbit_${user.id}_${idSession}.csv');
            fileFitbit.writeAsString(Fitbitcsv);
          }

          if (session.device1 == devices[1] || session.device2 == devices[1]) {
            //withings
            List<dynamic> headerWithings = [
              'idInterval',
              'timestamp',
              'value'
            ];
            List<List<dynamic>> rowsWithings = [];
            rowsWithings.add(headerWithings);
            for (int i = 0; i < intervals.length; i++) {
              List<WithingsRate> withingsSingleInterval =
                  await db.withingsRatesDao.withingsByInterval(intervals[i].id);
              withingsSingleInterval.forEach((element) {
                rowsWithings.add(
                    [element.idInterval, element.timestamp, element.value]);
              });
            }
            String Withingscsv = ListToCsvConverter().convert(rowsWithings);
            final fileWithings =
                File('$Spath/withings_${user.id}_${idSession}.csv');
            fileWithings.writeAsString(Withingscsv);
          }
        }
      },
    );
  }
  @override
  Future<void> close() async {
    await subStreamSession?.cancel();
    return super.close();
  }
}
