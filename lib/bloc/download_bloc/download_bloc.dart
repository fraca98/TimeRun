import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/model/credentials.dart';
import 'package:timerun/model/device.dart';
import 'package:withings_flutter/withings_flutter.dart';
import '../../database/AppDatabase.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  int idSession;
  AppDatabase db = GetIt.I<AppDatabase>();
  SharedPreferences prefs = GetIt.I<SharedPreferences>();
  StreamSubscription? subSession;

  DownloadBloc({required this.idSession}) : super(DownloadStateInitial()) {
    Stream<Session> session = db.sessionsDao.watchSession(idSession);
    subSession = session.listen((event) {
      //TODO:check
      emit(DownloadStateLoaded(session: event));
    });

    on<DownloadEventDownload>(
      (event, emit) async {
        subSession!.pause();
        final state = this.state as DownloadStateLoaded;
        emit(DownloadStateLoading(
            session: state.session, numTile: event.numTile));
        if (event.numTile == 1
            ? state.session.device1 == devices[0]
            : state.session.device2 == devices[0]) {
          //TODO: fix cause Fitbitter intraday?
          //Fitbit
          event.numTile == 1
              ? await db.sessionsDao.updateDown1(idSession, true)
              : await db.sessionsDao.updateDown2(idSession, true);

          print('Fitbit');
        }
        if (event.numTile == 1
            ? state.session.device1 == devices[1]
            : state.session.device2 == devices[1]) {
          //Withings
          bool error = false;
          List<int> idIntervaltoDel =
              []; //list of idIntervals cause if fails i need to remove all data
          List<Interval> interv =
              await db.intervalsDao.getIntervalBySession(idSession);
          try {
            for (var element in interv) {
              idIntervaltoDel.add(element.id);
              print(element.startstimestamp);
              print(element.endtimestamp);
              WithingsMeasureGetIntradayactivityData getintradayactivity =
                  await WithingsMeasureGetIntradayactivityDataManager()
                      .fetch(WithingsMeasureAPIURL.getIntradayactivity(
                accessToken: prefs.getString('withingsAccessToken')!,
                startdate: element.startstimestamp,
                enddate: element.endtimestamp,
                dataFields: 'heart_rate',
              ));
              if (getintradayactivity.status != 0) {
                //Here refresh the access token
                WithingsCredentials? newWithingsCredentials =
                    await WithingsConnector.refreshToken(
                        clientID: clientWithings[0],
                        clientSecret: clientWithings[1],
                        withingsRefreshToken:
                            prefs.getString('withingsRefreshToken')!);
                await prefs.setString('withingsAccessToken',
                    newWithingsCredentials!.withingsAccessToken);
                await prefs.setString('withingsRefreshToken',
                    newWithingsCredentials.withingsRefreshToken);
                error = true;
                break;
              }
              if (getintradayactivity.series == null) {
                error = true;
                break;
              } else {
                getintradayactivity.series!.forEach((instant) async {
                  await db.withingsRatesDao.insert(WithingsRatesCompanion(
                      idInterval: Value(element.id),
                      timestamp: Value(instant.timestamp!),
                      value: Value(instant.heartRate!)));
                }); //else save values
              }
            }
          } catch (e) {
            print(e);
            error = true;
          }
          if (error == false) {
            event.numTile == 1
                ? await db.sessionsDao.updateDown1(idSession, true)
                : await db.sessionsDao.updateDown2(idSession, true);
          } else {
            //error == true
            idIntervaltoDel.forEach((idtoDel) async {
              await db.withingsRatesDao.deleteInterval(
                  idtoDel); //delete all withingsData registered for previous intervals
            });
            emit(DownloadStateLoaded(
                session: state.session, error: true)); //emit with error
          }
        }
        if (event.numTile == 1
            ? state.session.device1 == devices[2]
            : state.session.device2 == devices[2]) {
          //Apple Watch

          event.numTile == 1
              ? await db.sessionsDao.updateDown1(idSession, true)
              : await db.sessionsDao.updateDown2(idSession, true);
          print('Apple Watch');
        }
        if (event.numTile == 1
            ? state.session.device1 == devices[3]
            : state.session.device2 == devices[3]) {
          //Garmin
          event.numTile == 1
              ? await db.sessionsDao.updateDown1(idSession, true)
              : await db.sessionsDao.updateDown2(idSession, true);
          print('Garmin');
        }
        subSession!.resume();
      },
    );
  }
}
