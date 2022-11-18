import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
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

    Future<List<WithingsRatesCompanion>?> _withingsDownload(
        Session session) async {
      bool error = false;
      List<WithingsRatesCompanion> withingsToSave = [];
      try {
        WithingsMeasureGetIntradayactivityData getWithingsSession =
            await WithingsMeasureGetIntradayactivityDataManager()
                .fetch(WithingsMeasureAPIURL.getIntradayactivity(
          accessToken: prefs.getString('withingsAccessToken')!,
          startdate: (session.start.toUtc().millisecondsSinceEpoch / 1000)
              .floor(), //use floor() cause i want timestamp in seconds considering only seconds of the datetime
          enddate: (session.end.toUtc().millisecondsSinceEpoch / 1000)
              .floor(), //use floor() cause i want timestamp in seconds considering only seconds of the datetime
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
              startdate: (session.start.toUtc().millisecondsSinceEpoch / 1000)
                  .floor(), //use floor() cause i want timestamp in seconds considering only seconds of the datetime
              enddate: (session.end.toUtc().millisecondsSinceEpoch / 1000)
                  .floor(), //use floor() cause i want timestamp in seconds considering only seconds of the datetime
              dataFields: 'heart_rate',
            )); //retry the request with refreshed tokens
          } else {
            error = true;
            m.debugPrint('Error refreshing tokens');
          }
        }
        if (getWithingsSession.status == 0) {
          if (getWithingsSession.series == null) {
            m.debugPrint('No data for this session');
            error = true;
          } else {
            getWithingsSession.series!.forEach((element) {
              withingsToSave.add(
                WithingsRatesCompanion(
                  idSession: Value(session.id),
                  time: Value(
                    DateTime.fromMillisecondsSinceEpoch(
                        element.timestamp! * 1000),
                  ),
                  rate: Value(element.heartRate!),
                ),
              );
            });
          }
        }
      } catch (e) {
        m.debugPrint(e.toString());
        error = true;
      }

      if (error == true) {
        return null;
      } else {
        return withingsToSave;
      }
    }

    Future<List<FitbitRatesCompanion>?> _fitbitDownload(Session session) async {
      bool error = false;
      List<FitbitRatesCompanion> fitbitToSave = [];
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
              startDate: session.start,
              endDate: session.end,
              intradayDetailLevel: IntradayDetailLevel.ONE_SECOND),
        ) as List<FitbitHeartRateIntradayData>;
        if (getFitbitSession.isEmpty) {
          m.debugPrint('No data for this session');
          error = true;
        } else {
          DateTime sessionStartNoAfterSec = DateTime.parse(
              DateFormat('yyyy-MM-dd HH:mm:ss').format(session
                  .start)); //session start and end remove micro/milliseconds to compare, cause dateOfMonitoring doesn't have these values (max returns seconds)
          DateTime sessionEndNoAfterSec = DateTime.parse(
              DateFormat('yyyy-MM-dd HH:mm:ss').format(session.end));
          //Warning: Fitbit data are returned considering the yyyy-MM-dd HH:mm and not the seconds (ss), so i have to cut data and keep only the one related to the session
          getFitbitSession.forEach((element) {
            if ((element.dateOfMonitoring!.isAfter(sessionStartNoAfterSec) &&
                    element.dateOfMonitoring!.isBefore(sessionEndNoAfterSec)) ||
                element.dateOfMonitoring!
                    .isAtSameMomentAs(sessionStartNoAfterSec) ||
                element.dateOfMonitoring!
                    .isAtSameMomentAs(sessionEndNoAfterSec)) {
              fitbitToSave.add(
                FitbitRatesCompanion(
                  idSession: Value(session.id),
                  time: Value(element.dateOfMonitoring!),
                  rate: Value(element.value!.toInt()),
                ),
              );
            }
          });
        }
      } catch (e) {
        m.debugPrint(e.toString());
        error = true;
      }

      if (error == true) {
        return null;
      } else {
        return fitbitToSave;
      }
    }

    on<DetailEventDownload>((event, emit) async {
      m.debugPrint('Pressed download');
      emit(DetailStateDownloading(
          session1: (state as DetailStateLoaded).session1,
          session2: (state as DetailStateLoaded).session2,
          downSession: event.numSession));

      bool error = false;
      List<FitbitRatesCompanion>? fitbitToSave;
      List<WithingsRatesCompanion>? withingsToSave;

      if (event.numSession == 1) {
        if (error == false &&
            ((state as DetailStateDownloading).session1!.device1 ==
                    devices[0] ||
                (state as DetailStateDownloading).session1!.device2 ==
                    devices[0])) {
          fitbitToSave = await _fitbitDownload(
              (state as DetailStateDownloading).session1!);
          fitbitToSave != null ? error = false : error = true;
          //print('1f');
        } //Fitbit
        if (error == false &&
            ((state as DetailStateDownloading).session1!.device1 ==
                    devices[1] ||
                (state as DetailStateDownloading).session1!.device2 ==
                    devices[1])) {
          withingsToSave = await _withingsDownload(
              (state as DetailStateDownloading).session1!);
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
              (state as DetailStateDownloading).session2!);
          fitbitToSave != null ? error = false : error = true;
          //print('2f');
        } //Fitbit
        if (error == false &&
            ((state as DetailStateDownloading).session2!.device1 ==
                    devices[1] ||
                (state as DetailStateDownloading).session2!.device2 ==
                    devices[1])) {
          withingsToSave = await _withingsDownload(
              (state as DetailStateDownloading).session2!);
          withingsToSave != null ? error = false : error = true;
          //print('2w');
        } //Withings
      }
      if (error == false) {
        fitbitToSave != null
            ? db.fitbitRatesDao.insertMultipleEntries(fitbitToSave)
            : null;
        withingsToSave != null
            ? db.withingsRatesDao.insertMultipleEntries(withingsToSave)
            : null;
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
            message: 'Error: Something went wrong'));
      }
    });

    on<DetailEventExport>(
      (event, emit) async {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage
              .request(); //if not permission, ask permission
          status = await Permission.storage.status;
        }
        if (!status.isGranted) {
          //if permission refused: return error
          emit(DetailStateLoaded(
              session1: (state as DetailStateLoaded).session1,
              session2: (state as DetailStateLoaded).session2,
              message: 'Error: Provide permission'));
        } else {
          // User csv
          List<dynamic> headerUser = ['id', 'sex', 'birthYear'];
          List<List<dynamic>> rowsUser = [];
          rowsUser.add(headerUser);
          rowsUser.add([user.id, user.sex, user.birthYear]);
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
            'start',
            'end',
            'device1',
            'device2'
          ]);
          if (event.numSession == 1) {
            rowsSession.add([
              (state as DetailStateLoaded).session1!.id,
              (state as DetailStateLoaded).session1!.idUser,
              (state as DetailStateLoaded).session1!.numsession,
              (state as DetailStateLoaded).session1!.start,
              (state as DetailStateLoaded).session1!.end,
              (state as DetailStateLoaded).session1!.device1,
              (state as DetailStateLoaded).session1!.device2
            ]);
          } else {
            rowsSession.add([
              (state as DetailStateLoaded).session2!.id,
              (state as DetailStateLoaded).session2!.idUser,
              (state as DetailStateLoaded).session2!.numsession,
              (state as DetailStateLoaded).session2!.start,
              (state as DetailStateLoaded).session2!.end,
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
          rowsIntervals.add(
              ['id', 'idSession', 'runStatus', 'start', 'end', 'deltatime']);
          intervals.forEach((element) {
            rowsIntervals.add([
              element.id,
              element.idSession,
              element.runStatus,
              element.start,
              element.end,
              element.deltatime
            ]);
          });
          String Intervalcsv = ListToCsvConverter().convert(rowsIntervals);
          final fileInterval =
              File('$Spath/intervals_${user.id}_${idSession}.csv');
          fileInterval.writeAsString(Intervalcsv);

          // Polar csv
          List<dynamic> headerPolar = ['time', 'rate'];
          List<List<dynamic>> rowsPolar = [];
          rowsPolar.add(headerPolar);
          List<PolarRate> polarSessionExp =
              await db.polarRatesDao.polarBySession(idSession);
          polarSessionExp.forEach((element) {
            rowsPolar.add([element.time, element.rate]);
          });
          String Polarcsv = ListToCsvConverter().convert(rowsPolar);
          final filePolar = File('$Spath/polar_${user.id}_${idSession}.csv');
          filePolar.writeAsString(Polarcsv);

          Session session;
          event.numSession == 1
              ? session = (state as DetailStateLoaded).session1!
              : session = (state as DetailStateLoaded).session2!;
          if (session.device1 == devices[0] || session.device2 == devices[0]) {
            //fitbit
            List<dynamic> headerFitbit = ['time', 'rate'];
            List<List<dynamic>> rowsFitbit = [];
            rowsFitbit.add(headerFitbit);
            List<FitbitRate> fitbitSessionExp =
                await db.fitbitRatesDao.fitbitBySession(idSession);
            fitbitSessionExp.forEach((element) {
              rowsFitbit.add([element.time, element.rate]);
            });
            String Fitbitcsv = ListToCsvConverter().convert(rowsFitbit);
            final fileFitbit =
                File('$Spath/fitbit_${user.id}_${idSession}.csv');
            fileFitbit.writeAsString(Fitbitcsv);
          }

          if (session.device1 == devices[1] || session.device2 == devices[1]) {
            //withings
            List<dynamic> headerWithings = ['time', 'value'];
            List<List<dynamic>> rowsWithings = [];
            rowsWithings.add(headerWithings);
            List<WithingsRate> withingsSessionExp =
                await db.withingsRatesDao.withingsBySession(idSession);
            withingsSessionExp.forEach((element) {
              rowsWithings.add([element.time, element.rate]);
            });
            String Withingscsv = ListToCsvConverter().convert(rowsWithings);
            final fileWithings =
                File('$Spath/withings_${user.id}_${idSession}.csv');
            fileWithings.writeAsString(Withingscsv);
          }
          emit(DetailStateLoaded(
              session1: (state as DetailStateLoaded).session1,
              session2: (state as DetailStateLoaded).session2,
              message: 'Session exported'));
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
