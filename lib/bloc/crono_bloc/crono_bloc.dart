import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/status.dart';
part 'crono_event.dart';
part 'crono_state.dart';

class CronoBloc extends Bloc<CronoEvent, CronoState> {
  int progressIndex;
  int? starttimestamp;
  int? endtimestamp;

  int? idSession;

  CronoBloc(
      {this.progressIndex = 0,
      required int idUser,
      required List<String> sessionDevices,
      required int numSession})
      : super(CronoStatePlay(progressIndex: progressIndex)) {
    AppDatabase db = GetIt.I<AppDatabase>();

    on<CronoEventPlay>(
      (event, emit) {
        emit(CronoStateRunning(progressIndex: progressIndex));
        starttimestamp =
            (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
        print('starttimestamp: $starttimestamp');
      },
    );

    on<CronoEventPause>(
      (event, emit) {
        emit(CronoStatePause(progressIndex: progressIndex));
      },
    );

    on<CronoEventStop>((event, emit) {
      emit(CronoStateStop(progressIndex: progressIndex));
      endtimestamp =
          (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
      print('endtimestamp: $endtimestamp');
    });

    on<CronoEventResume>(
      (event, emit) {
        emit(CronoStateRunning(progressIndex: progressIndex));
      },
    );

    on<CronoEventSave>((event, emit) async {
      emit(CronoStateLoading(progressIndex: progressIndex));
      print("Save timestamp");

      if (progressIndex == 0) {
        //if i save (for progressindex = 0)
        idSession = await db.sessionsDao.inserNewSession(SessionsCompanion(
            //insert a new session
            startsession: Value(starttimestamp),
            device1: Value(sessionDevices[0]),
            device2: Value(sessionDevices[1])));
        //print(idSession);
        numSession == 1
            ? await db.usersDao.assignSession1(idUser, idSession!)
            : await db.usersDao.assignSession2(
                idUser, idSession!); // add the session1/2 for the user
        //print(await db.sessionsDao.allEntries);
      }

      await db.intervalsDao.inserNewInterval(IntervalsCompanion(
        idSession: Value(idSession!),
        status: Value(status[progressIndex]),
        startstimestamp: Value(starttimestamp!),
        endtimestamp: Value(endtimestamp!),
        deltatime: Value(endtimestamp! - starttimestamp!),
      ));
      //await Future.delayed(Duration(seconds: 1));
      progressIndex++;

      if (progressIndex == 5) {
        //end the session of data collection
        await db.sessionsDao.updateSession(idSession!, endtimestamp!); //update endtimestamp of session
        emit(CronoStateCompleted(progressIndex: progressIndex));
      } else {
        emit(CronoStatePlay(progressIndex: progressIndex));
      }
    });

    on<CronoEventDelete>(
      (event, emit) {
        emit(CronoStatePlay(progressIndex: progressIndex));
        starttimestamp = null;
        endtimestamp = null;
        print('Cancel timestamp');
        print('starttimestamp: $starttimestamp');
        print('endtimestamp: $endtimestamp');
      },
    );
  }
}
