import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/status.dart';
import 'package:timerun/model/ticker.dart';
part 'crono_event.dart';
part 'crono_state.dart';

class CronoBloc extends Bloc<CronoEvent, CronoState> {
  int? starttimestamp;
  int? endtimestamp;
  int? idSession;
  AppDatabase db = GetIt.I<AppDatabase>();
  int progressIndex = 0;

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  CronoBloc(
      {required int idUser,
      required List<String> sessionDevices,
      required int numSession,
      required Ticker ticker})
      : _ticker = ticker,
        super(CronoStatePlay(progressIndex: 0, duration: 0)) {
    on<CronoEventPlay>(
      (event, emit) {
        emit(CronoStateRunning(
            progressIndex: progressIndex, duration: event.duration));
        starttimestamp =
            (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
        //print('starttimestamp: $starttimestamp');
        _tickerSubscription?.cancel();
        _tickerSubscription = _ticker
            .tick(ticks: event.duration)
            .listen((duration) => add(CronoEventTicked(duration: duration)));
      },
    );

    on<CronoEventPause>(
      (event, emit) {
        _tickerSubscription?.pause();
        emit(CronoStatePause(
            progressIndex: progressIndex, duration: state.duration));
      },
    );

    on<CronoEventStop>((event, emit) {
      _tickerSubscription?.cancel();
      //print(state); //CronoStatePause
      emit(CronoStateStop(
          progressIndex: progressIndex, duration: state.duration));
      endtimestamp =
          (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
      //print('endtimestamp: $endtimestamp');
    });

    on<CronoEventResume>(
      (event, emit) {
        _tickerSubscription?.resume();
        emit(CronoStateRunning(
            progressIndex: progressIndex, duration: state.duration));
      },
    );

    on<CronoEventSave>((event, emit) async {
      emit(CronoStateSaving(
          progressIndex: progressIndex, duration: state.duration));
      //print("Save timestamp");
      if (progressIndex == 0) {
        //if i save (for progressindex = 0)
        idSession = await db.sessionsDao.inserNewSession(SessionsCompanion(
            //insert a new session
            iduser: Value(idUser),
            startsession: Value(starttimestamp!),
            device1: Value(sessionDevices[0]),
            device2: Value(sessionDevices[1]),
            numsession: Value(numSession)));
        //print(idSession);
      }

      await db.intervalsDao.inserNewInterval(IntervalsCompanion(
        idSession: Value(idSession!),
        status: Value(status[progressIndex]),
        startstimestamp: Value(starttimestamp!),
        endtimestamp: Value(endtimestamp!),
        deltatime: Value(endtimestamp! - starttimestamp!),
      ));
      progressIndex++;

      if (progressIndex == 5) {
        //end the session of data collection
        await db.sessionsDao.updateSession(
            idSession!, endtimestamp!); //update endtimestamp of session
        numSession ==
                1 //update the completed (number of completed session for the user)
            ? await db.usersDao.updateComplete(idUser, 1)
            : await db.usersDao.updateComplete(idUser, 2);
        emit(CronoStateCompleted(
            progressIndex: progressIndex, duration: state.duration));
      } else {
        emit(CronoStatePlay(progressIndex: progressIndex, duration: 0));
      }
    });

    on<CronoEventDelete>(
      (event, emit) {
        emit(CronoStatePlay(progressIndex: progressIndex, duration: 0));
        starttimestamp = null;
        endtimestamp = null;
        //print('Cancel timestamp');
        //print('starttimestamp: $starttimestamp');
        //print('endtimestamp: $endtimestamp');
      },
    );

    on<CronoEventDeleteSession>(
      (event, emit) async {
        emit(CronoStateDeletingSession(
            progressIndex: progressIndex, duration: state.duration));
        if (idSession != null) {
          await db.sessionsDao
              .deleteSession(idSession!); //delete the session if already saved
        } else {}
        emit(CronoStateDeletedSession(
            progressIndex: progressIndex, duration: state.duration));
      },
    );

    on<CronoEventTicked>(
      (event, emit) {
        emit(CronoStateRunning(
            progressIndex: progressIndex, duration: event.duration));
      },
    );
  }
}
