import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:polar/polar.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/device.dart';
import 'package:timerun/model/ticker.dart';

import '../../model/status.dart';
part 'crono_event.dart';
part 'crono_state.dart';

class CronoBloc extends Bloc<CronoEvent, CronoState> {
  int? idSession;
  AppDatabase db = GetIt.I<AppDatabase>();
  int progressIndex = 0;

  Polar polar;

  Ticker ticker = Ticker();
  StreamSubscription<int>? tickerSubscription;
  StreamSubscription? hrSubscription;
  StreamSubscription? bluePolar;
  StreamSubscription? batteryPolar;
  DateTime? startTimeInterval;
  DateTime? endTimeInterval;
  List<timeInterval> listTimeIntervals = [];

  List<PolarRatesCompanion> polarToSave = [];

  CronoBloc({
    required this.polar,
    required int idUser,
    required List<String> sessionDevices,
    required int numSession,
  }) : super(CronoStateInit()) {
    batteryPolar = polar.batteryLevelStream.listen((event) {
      print('Battery level ${event.level}');
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
      print('Disconnected from Bluetooth');
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
      print('Polar HR: ${event.data.hr}');
      polarToSave.add(PolarRatesCompanion(
          time: Value(DateTime.now()), rate: Value(event.data.hr)));

      String? error;
      if (event.data.hr == 0) {
        print('No contact');
        error = "No contact";
        //polar shut down or no contact
      }

      if (state is CronoStateInit) {
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
      if (state is CronoStateSaving) {
        emit(CronoStateSaving());
      }
      if (state is CronoStateCompleted) {
        emit(CronoStateCompleted());
      }
    });
    on<CronoEventPlay>((event, emit) {
      if ((state as CronoStateExt).hr != 0) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: (state as CronoStateExt).hr,
            battery: (state as CronoStateExt).battery));
        startTimeInterval = DateTime.now();
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
      print(polarToSave);
      listTimeIntervals
          .add(timeInterval(start: startTimeInterval!, end: endTimeInterval!));
      startTimeInterval = null;
      endTimeInterval = null;
      progressIndex++;

      if (progressIndex == status.length) {
        emit(CronoStateSaving());
        //end the session of data collection
        //print(polarToSave);
        await hrSubscription?.cancel(); //stop collecting heart data
        await bluePolar?.cancel();
        await batteryPolar?.cancel();
        await polar.disconnectFromDevice(polarIdentifier); //disconnect Polar

        int idSession = await db.sessionsDao.inserNewSession(SessionsCompanion(
            iduser: Value(idUser),
            numsession: Value(numSession),
            start: Value(listTimeIntervals.first.start),
            end: Value(listTimeIntervals.last.end),
            device1: Value(sessionDevices[0]),
            device2: Value(sessionDevices[1])));

        for (int i = 0; i < status.length; i++) {
          await db.intervalsDao.inserNewInterval(IntervalsCompanion(
            //Save the new interval
            idSession: Value(idSession),
            runstatus: Value(i),
            start: Value(listTimeIntervals[i].start),
            end: Value(listTimeIntervals[i].end),
            deltatime: Value(listTimeIntervals[i]
                .end
                .difference(listTimeIntervals[i].start)
                .inSeconds),
          ));
          for (int j = 0; j < polarToSave.length; j++) {
            await db.polarRatesDao.insert(PolarRatesCompanion(
              idSession: Value(idSession),
              time: polarToSave[j].time,
              rate: polarToSave[j].rate,
            ));
          }
        }
        numSession ==
                1 //update the completed (number of completed session for the user)
            ? await db.usersDao.updateComplete(idUser, 1)
            : await db.usersDao.updateComplete(idUser, 2);

        await Future.delayed(Duration(seconds: 2)); //to show animation

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
