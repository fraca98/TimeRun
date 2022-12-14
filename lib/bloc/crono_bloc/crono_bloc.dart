import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:polar/polar.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/device.dart';
import 'package:timerun/model/ticker.dart';
import 'package:vibration/vibration.dart';

import '../../model/status.dart';
part 'crono_event.dart';
part 'crono_state.dart';

class CronoBloc extends Bloc<CronoEvent, CronoState> {
  int? idSession;
  int progressIndex = 0;

  Ticker ticker = Ticker();
  StreamSubscription<int>? tickerSubscription;

  StreamSubscription? hrSubscription;
  StreamSubscription? bluePolar;
  StreamSubscription? batteryPolar;
  List<PolarRatesCompanion> polarToSave = [];

  DateTime? startTimeInterval;
  DateTime? endTimeInterval;
  List<timeInterval> listTimeIntervals = [];

  AppDatabase db = GetIt.I<AppDatabase>();

  CronoBloc({
    required Polar polar,
    required int idUser,
    required List<String> sessionDevices,
    required int numSession,
    required List<int> minHr,
    required List<int> maxHr,
    required int maxHrValue,
  }) : super(CronoStateInit()) {
    batteryPolar = polar.batteryLevelStream.listen((event) {
      debugPrint('Battery level ${event.level}');
      if (state is CronoStateInit) {
        emit(
          CronoStateInit(battery: event.level),
        );
      }
      if (state is CronoStatePlay) {
        emit(
          CronoStatePlay(
              progressIndex: progressIndex,
              duration: (state as CronoStatePlay).duration,
              hr: (state as CronoStatePlay).hr,
              message: (state as CronoStatePlay).message,
              battery: event.level),
        );
      }
      if (state is CronoStateRunning) {
        emit(
          CronoStateRunning(
              progressIndex: progressIndex,
              duration: (state as CronoStateRunning).duration,
              hr: (state as CronoStateRunning).hr,
              battery: event.level),
        );
      }
      if (state is CronoStatePause) {
        emit(
          CronoStatePause(
              progressIndex: progressIndex,
              duration: (state as CronoStatePause).duration,
              hr: (state as CronoStatePause).hr,
              message: (state as CronoStatePause).message,
              battery: event.level),
        );
      }
      if (state is CronoStateStop) {
        emit(
          CronoStateStop(
              progressIndex: progressIndex,
              duration: (state as CronoStateStop).duration,
              hr: (state as CronoStateStop).hr,
              message: (state as CronoStateStop).message,
              battery: event.level),
        );
      }
    });

    bluePolar = polar.deviceDisconnectedStream.listen((event) {
      Vibration.vibrate(
          duration: 400); //vibrate if Bluetooth connection interrupts
      debugPrint('Disconnected from Bluetooth');
      String error = "Disconnected from Bluetooth";
      if (state is CronoStateInit) {
        emit(CronoStatePlay(
            progressIndex: progressIndex, duration: 0, hr: 0, message: error));
      }
      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: (state as CronoStatePlay).duration,
            hr: 0,
            message: error));
      }
      if (state is CronoStateRunning) {
        add(CronoEventPause(message: error));
      }
      if (state is CronoStatePause) {
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: (state as CronoStatePause).duration,
            hr: 0,
            message: error));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: (state as CronoStateStop).duration,
            hr: 0,
            message: error));
      }
    });

    hrSubscription = polar.heartRateStream.listen((event) {
      debugPrint('Polar HR: ${event.data.hr}');
      polarToSave.add(PolarRatesCompanion(
          time: Value(DateTime.now()),
          rate: Value(event.data.hr))); // add Polar data

      if (state is CronoStateExt) {
        //manage vibration across the interval
        if (((state as CronoStateExt).hr < minHr[progressIndex] ||
                (state as CronoStateExt).hr > maxHr[progressIndex]) &&
            (event.data.hr >= minHr[progressIndex] &&
                event.data.hr <= maxHr[progressIndex])) {
          //out --> in
          Vibration.vibrate(duration: 400);
          debugPrint('Out-->In in the interval');
        }
        if (((state as CronoStateExt).hr >= minHr[progressIndex] &&
                (state as CronoStateExt).hr <= maxHr[progressIndex]) &&
            (event.data.hr < minHr[progressIndex] ||
                event.data.hr > maxHr[progressIndex])) {
          //in --> out
          Vibration.vibrate(duration: 400);
          debugPrint('In-->Out in the interval');
        }
      }

      String? error;
      if (event.data.hr == 0) {
        debugPrint('No contact');
        error = "No contact";
        //polar shut down or no contact
      }

      if (state is CronoStateInit) {
        Vibration.vibrate(
            duration:
                400); // vibrate when CronoStatPlay appears for the first time (so first hr emitted by Polar)
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: 0,
            hr: event.data.hr,
            message: error,
            battery: (state as CronoStateInit).battery));
      }
      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: (state as CronoStatePlay).duration,
            hr: event.data.hr,
            message: error,
            battery: (state as CronoStatePlay).battery));
      }
      if (state is CronoStateRunning) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: (state as CronoStateRunning).duration,
            hr: event.data.hr,
            message: error,
            battery: (state as CronoStateRunning).battery));
      }

      if (state is CronoStatePause) {
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: (state as CronoStatePause).duration,
            hr: event.data.hr,
            message: error,
            battery: (state as CronoStatePause).battery));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: (state as CronoStateStop).duration,
            hr: event.data.hr,
            message: error,
            battery: (state as CronoStateStop).battery));
      }
    });

    on<CronoEventPlay>((event, emit) {
      if ((state as CronoStateExt).hr != 0) {
        startTimeInterval = DateTime.now();
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: (state as CronoStateExt).hr,
            battery: (state as CronoStateExt).battery));

        tickerSubscription?.cancel();
        tickerSubscription = ticker
            .tick(ticks: event.duration)
            .listen((duration) => add(CronoEventTicked(duration: duration)));
      }
    });

    on<CronoEventPause>(
      (event, emit) {
        endTimeInterval = DateTime.now();
        tickerSubscription?.pause();
        event.message == null
            ? emit(CronoStatePause(
                progressIndex: progressIndex,
                duration: (state as CronoStateExt).duration,
                hr: (state as CronoStateExt).hr,
                message: event.message,
                battery: (state as CronoStateExt).battery,
              ))
            : emit(CronoStatePause(
                progressIndex: progressIndex,
                duration: (state as CronoStateExt).duration,
                hr: 0,
                message: event.message,
                battery: (state as CronoStateExt).battery,
              ));
      },
    );

    on<CronoEventStop>((event, emit) {
      tickerSubscription?.cancel();
      if (endTimeInterval != null) {
      } else {
        endTimeInterval = DateTime.now();
      }
      (state as CronoStateExt).message == null
          ? emit(CronoStateStop(
              progressIndex: progressIndex,
              duration: (state as CronoStateExt).duration,
              hr: (state as CronoStateExt).hr,
              message: (state as CronoStateExt).message,
              battery: (state as CronoStateExt).battery,
            ))
          : emit(CronoStateStop(
              progressIndex: progressIndex,
              duration: (state as CronoStateExt).duration,
              hr: 0,
              message: (state as CronoStateExt).message,
              battery: (state as CronoStateExt).battery,
            ));
    });

    on<CronoEventResume>(
      (event, emit) {
        if ((state as CronoStateExt).hr != 0) {
          endTimeInterval = null;
          tickerSubscription?.resume();
          emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: (state as CronoStateExt).duration,
            hr: (state as CronoStateExt).hr,
            battery: (state as CronoStateExt).battery,
          ));
        }
      },
    );

    on<CronoEventSave>((event, emit) async {
      listTimeIntervals
          .add(timeInterval(start: startTimeInterval!, end: endTimeInterval!));
      startTimeInterval = null;
      endTimeInterval = null;
      progressIndex++;

      if (progressIndex == status.length) {
        emit(CronoStateSaving());
        //end the session of data collection
        await hrSubscription?.cancel(); //stop collecting heart data
        await bluePolar?.cancel();
        await batteryPolar?.cancel();
        await polar.disconnectFromDevice(polarIdentifier); //disconnect Polar

        int idSession = await db.sessionsDao.insertNewSession(SessionsCompanion(
            idUser: Value(idUser),
            numsession: Value(numSession),
            start: polarToSave.first.time,
            end: Value(listTimeIntervals.last.end),
            device1: Value(sessionDevices[0]),
            device2: Value(sessionDevices[1])));

        for (int i = 0; i < status.length; i++) {
          await db.intervalsDao.inserNewInterval(IntervalsCompanion(
            //Save the new interval
            idSession: Value(idSession),
            runStatus: Value(i),
            start: Value(listTimeIntervals[i].start),
            end: Value(listTimeIntervals[i].end),
            deltatime: Value(listTimeIntervals[i]
                .end
                .difference(listTimeIntervals[i].start)
                .inSeconds),
          ));
        }

        await db.polarRatesDao.insertMultipleEntries(polarToSave, idSession);

        numSession ==
                1 //update the completed (number of completed session for the user)
            ? await db.usersDao.updateComplete(idUser, 1)
            : await db.usersDao.updateComplete(idUser, 2);

        await Future.delayed(Duration(seconds: 2)); //to see the animation

        emit(CronoStateCompleted());
      } else {
        emit(CronoStatePlay(
          progressIndex: progressIndex,
          duration: 0,
          hr: (state as CronoStateExt).hr,
          message: (state as CronoStateExt).message,
          battery: (state as CronoStateExt).battery,
        ));
      }
    });

    on<CronoEventDelete>(
      (event, emit) {
        startTimeInterval = null;
        endTimeInterval = null;
        emit(CronoStatePlay(
          progressIndex: progressIndex,
          duration: 0,
          hr: (state as CronoStateExt).hr,
          message: (state as CronoStateExt).message,
          battery: (state as CronoStateExt).battery,
        ));
      },
    );

    on<CronoEventDeleteSession>(
      (event, emit) async {
        await hrSubscription?.cancel(); //stop collecting heart data
        await bluePolar?.cancel();
        await batteryPolar?.cancel();
        await polar.disconnectFromDevice(polarIdentifier); //disconnect polar
      },
    );

    on<CronoEventTicked>(
      (event, emit) {
        emit(
          CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: (state as CronoStateRunning).hr,
            message: (state as CronoStateRunning).message,
            battery: (state as CronoStateRunning).battery,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await hrSubscription?.cancel();
    await bluePolar?.cancel();
    await tickerSubscription?.cancel();
    await batteryPolar?.cancel();
    return super.close();
  }
}

class timeInterval {
  DateTime start;
  DateTime end;
  timeInterval({required this.start, required this.end});
}
