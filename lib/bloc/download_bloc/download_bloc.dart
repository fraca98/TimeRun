import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerun/model/device.dart';
import 'package:withings_flutter/withings_flutter.dart';
import '../../database/AppDatabase.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  int idSession;
  AppDatabase db = GetIt.I<AppDatabase>();
  SharedPreferences prefs = GetIt.I<SharedPreferences>();

  DownloadBloc({required this.idSession}) : super(DownloadStateInitial()) {
    Stream<Session> session = db.sessionsDao.watchSession(idSession);
    session.listen((event) {
      if (isClosed == false) {
        emit(DownloadStateLoaded(session: event));
      }
    });

    on<DownloadEventDownload>(
      (event, emit) async {
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
            : state.session.device2 == devices[1]) { //need to insert thw way to refresh token
          //Withings
          List<Interval> interv =
              await db.intervalsDao.getIntervalBySession(idSession);
          for (var element in interv) {
            WithingsMeasureGetIntradayactivityData getintradayactivity =
                await WithingsMeasureGetIntradayactivityDataManager()
                    .fetch(WithingsMeasureAPIURL.getIntradayactivity(
              accessToken: prefs.getString('withingsAccessToken')!,
              startdate: element.startstimestamp,
              enddate: element.endtimestamp,
              dataFields: 'heart_rate',
            ));
            if (getintradayactivity.series == null) {
              //TODO: implement delete if some data not present
              emit(DownloadStateLoaded(session: state.session, error: true));
              break;
            } else {
              getintradayactivity.series!.forEach((instant) async {
                await db.withingsRatesDao.insert(WithingsRatesCompanion(
                    idInterval: Value(element.id),
                    timestamp: Value(instant.timestamp!),
                    value: Value(instant.heartRate!)));
              });
            }
            event.numTile == 1
                ? await db.sessionsDao.updateDown1(idSession, true)
                : await db.sessionsDao.updateDown2(idSession, true);
          }
          print('Withings');
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
      },
    );
  }
}
