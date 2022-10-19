import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:polar/polar.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/device.dart';
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

  Ticker ticker = Ticker();
  StreamSubscription<int>? tickerSubscription;
  StreamSubscription? hrSubscription;

  List<int> polarTimestamp = [];
  List<int> polarValue = [];

  CronoBloc({
    required int idUser,
    required List<String> sessionDevices,
    required int numSession,
  }) : super(CronoStateInit(progressIndex: 0, duration: 0, hr: 0)) {
    //TODO: fix the initial state
    hrSubscription = Polar().heartRateStream.listen((event) {
      print(event.data.hr);
      if (state is CronoStateInit) {
        emit(CronoStatePlay(
            progressIndex: progressIndex, duration: 0, hr: event.data.hr));
      }

      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateRunning) {
        //if the value for the starting timestamp is already registered do NOT insert it
        int actualTimestamp =
            (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
        if (polarTimestamp.contains(actualTimestamp) == false) {
          polarTimestamp.add(actualTimestamp);
          polarValue.add(event.data.hr);
        }

        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStatePause) {
        polarTimestamp.add(
            (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor());
        polarValue.add(event.data.hr);
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateSaving) {
        emit(CronoStateSaving(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateCompleted) {
        emit(CronoStateCompleted(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateDeletingSession) {
        emit(CronoStateDeletingSession(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateDeletedSession) {
        emit(CronoStateDeletedSession(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
    });
    on<CronoEventPlay>(
      (event, emit) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: state.hr));

        starttimestamp = null;
        endtimestamp = null;
        polarTimestamp.clear();
        polarValue.clear();

        starttimestamp =
            (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
        //print('starttimestamp: $starttimestamp');

        polarTimestamp.add(starttimestamp!);
        polarValue.add(state.hr);

        tickerSubscription?.cancel();
        tickerSubscription = ticker
            .tick(ticks: event.duration)
            .listen((duration) => add(CronoEventTicked(duration: duration)));
      },
    );

    on<CronoEventPause>(
      (event, emit) {
        tickerSubscription?.pause();
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));
      },
    );

    on<CronoEventStop>((event, emit) {
      tickerSubscription?.cancel();
      //print(state); //CronoStatePause
      emit(CronoStateStop(
          progressIndex: progressIndex,
          duration: state.duration,
          hr: state.hr));
      endtimestamp =
          (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
      //print('endtimestamp: $endtimestamp');

      //if already present do NOT insert endtimestamp and value
      if (polarTimestamp.contains(endtimestamp) == false) {
        polarTimestamp.add(endtimestamp!);
        polarValue.add(state.hr);
      }

      /*print(polarTimestamp);
      print(polarValue);
      print(starttimestamp);
      print(endtimestamp);*/
    });

    on<CronoEventResume>(
      (event, emit) {
        tickerSubscription?.resume();
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));
      },
    );

    on<CronoEventSave>((event, emit) async {
      emit(CronoStateSaving(
          progressIndex: progressIndex,
          duration: state.duration,
          hr: state.hr));
      //print("Save timestamp");
      if (progressIndex == 0) {
        //if i save (for progressindex = 0)
        idSession = await db.sessionsDao.inserNewSession(SessionsCompanion(
          //insert a new session
          iduser: Value(idUser),
          startsession: Value(starttimestamp!),
          device1: Value(sessionDevices[0]),
          device2: Value(sessionDevices[1]),
          numsession: Value(numSession),
        )); //download 1,2 by default false
        //print(idSession);
      }

      int idInterv = await db.intervalsDao.inserNewInterval(IntervalsCompanion(
        //Save the new interval
        idSession: Value(idSession!),
        status: Value(status[progressIndex]),
        startstimestamp: Value(starttimestamp!),
        endtimestamp: Value(endtimestamp!),
        deltatime: Value(endtimestamp! - starttimestamp! + 1), //delta + 1
      ));

      for (int i = 0; i < polarTimestamp.length; i++) {
        await db.polarRatesDao.insert(PolarRatesCompanion(
            idInterval: Value(idInterv),
            timestamp: Value(polarTimestamp[i]),
            value: Value(polarValue[i])));
      } //save values of heart for Polar in the PolarRates table

      progressIndex++;

      if (progressIndex == 5) {
        //end the session of data collection
        await db.sessionsDao.updateEndSession(
            idSession!, endtimestamp!); //update endtimestamp of session
        numSession ==
                1 //update the completed (number of completed session for the user)
            ? await db.usersDao.updateComplete(idUser, 1)
            : await db.usersDao.updateComplete(idUser, 2);
        hrSubscription!.cancel(); //stop collecting heart data
        Polar().disconnectFromDevice(polarIdentifier); //disconnect Polar
        emit(CronoStateCompleted(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));
      } else {
        emit(CronoStatePlay(
            progressIndex: progressIndex, duration: 0, hr: state.hr));
      }
    });

    on<CronoEventDelete>(
      (event, emit) {
        emit(CronoStatePlay(
            progressIndex: progressIndex, duration: 0, hr: state.hr));
        starttimestamp = null;
        endtimestamp = null;
        //print('Cancel timestamp');
        //print('starttimestamp: $starttimestamp');
        //print('endtimestamp: $endtimestamp');
        polarTimestamp.clear();
        polarValue.clear();
      },
    );

    on<CronoEventDeleteSession>(
      (event, emit) async {
        emit(CronoStateDeletingSession(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));
        if (idSession != null) {
          await db.sessionsDao
              .deleteSession(idSession!); //delete the session if already saved
        } else {}

        starttimestamp = null;
        endtimestamp = null;
        polarTimestamp.clear();
        polarValue.clear();

        hrSubscription!.cancel(); //stop collecting heart data
        Polar().disconnectFromDevice(polarIdentifier); //disconnect polar
        emit(CronoStateDeletedSession(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));
      },
    );
    on<CronoEventTicked>(
      (event, emit) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: state.hr));
      },
    );
  }
}
