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

  List<List<PolarRatesCompanion>> polarToSave =
      List.generate(status.length, (index) => []);

  CronoBloc({
    required this.polar,
    required int idUser,
    required List<String> sessionDevices,
    required int numSession,
  }) : super(CronoStateInit()) {
    batteryPolar = polar.batteryLevelStream.listen((event) {
      print(event.level);
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
              errorMessage: (state as CronoStatePlay).errorMessage,
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
              errorMessage: (state as CronoStatePause).errorMessage,
              battery: event.level),
        );
      }
      if (state is CronoStateStop) {
        emit(
          CronoStateStop(
              progressIndex: progressIndex,
              duration: (state as CronoStateStop).duration,
              hr: (state as CronoStateStop).hr,
              errorMessage: (state as CronoStateStop).errorMessage,
              battery: event.level),
        );
      }
    });

    bluePolar = polar.deviceDisconnectedStream.listen((event) {
      print('Disconnected from Bluetooth');
      String error = "Disconnected from Bluetooth";
      if (state is CronoStateInit) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: 0,
            hr: 0,
            errorMessage: error));
      }
      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: (state as CronoStatePlay).duration,
            hr: 0,
            errorMessage: error));
      }
      if (state is CronoStateRunning) {
        add(CronoEventPause(errorMessage: error));
      }
      if (state is CronoStatePause) {
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: (state as CronoStatePause).duration,
            hr: 0,
            errorMessage: error));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: (state as CronoStateStop).duration,
            hr: 0,
            errorMessage: error));
      }
    });

    hrSubscription = polar.heartRateStream.listen((event) {
      print('Polar HR: ${event.data.hr}');
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
            errorMessage: error,
            battery: (state as CronoStateInit).battery));
      }
      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: (state as CronoStatePlay).duration,
            hr: event.data.hr,
            errorMessage: error,
            battery: (state as CronoStatePlay).battery));
      }
      if (state is CronoStateRunning) {
        if (event.data.hr != 0) {
          polarToSave[progressIndex].add(PolarRatesCompanion(
              timestamp: Value(
                  (DateTime.now().toUtc().millisecondsSinceEpoch / 1000)
                      .floor()),
              value: Value(event.data.hr)));
          emit(CronoStateRunning(
              progressIndex: progressIndex,
              duration: (state as CronoStateRunning).duration,
              hr: event.data.hr,
              battery: (state as CronoStateRunning).battery));
        } else {
          add(CronoEventPause(errorMessage: error));
        }
      }

      if (state is CronoStatePause) {
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: (state as CronoStatePause).duration,
            hr: event.data.hr,
            errorMessage: error,
            battery: (state as CronoStatePause).battery));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: (state as CronoStateStop).duration,
            hr: event.data.hr,
            errorMessage: error,
            battery: (state as CronoStateStop).battery));
      }
      if (state is CronoStateSaving) {
        //saving and complete should remove all {}
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

        tickerSubscription?.cancel();
        tickerSubscription = ticker
            .tick(ticks: event.duration)
            .listen((duration) => add(CronoEventTicked(duration: duration)));
      }
    });

    on<CronoEventPause>(
      (event, emit) {
        tickerSubscription?.pause();
        event.errorMessage == null
            ? emit(CronoStatePause(
                progressIndex: progressIndex,
                duration: (state as CronoStateExt).duration,
                hr: (state as CronoStateExt).hr,
                errorMessage: event.errorMessage,
                battery: (state as CronoStateExt).battery,
              ))
            : emit(CronoStatePause(
                progressIndex: progressIndex,
                duration: (state as CronoStateExt).duration,
                hr: 0,
                errorMessage: event.errorMessage,
                battery: (state as CronoStateExt).battery,
              ));
      },
    );

    on<CronoEventStop>((event, emit) {
      tickerSubscription?.cancel();
      (state as CronoStateExt).errorMessage == null
          ? emit(CronoStateStop(
              progressIndex: progressIndex,
              duration: (state as CronoStateExt).duration,
              hr: (state as CronoStateExt).hr,
              errorMessage: (state as CronoStateExt).errorMessage,
              battery: (state as CronoStateExt).battery,
            ))
          : emit(CronoStateStop(
              progressIndex: progressIndex,
              duration: (state as CronoStateExt).duration,
              hr: 0,
              errorMessage: (state as CronoStateExt).errorMessage,
              battery: (state as CronoStateExt).battery,
            ));

      /*print(polarToSave);
      if (polarToSave[progressIndex].isNotEmpty) {
        print(polarToSave[progressIndex].first);
        print(polarToSave[progressIndex].last);
      }*/
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
      if (polarToSave[progressIndex].isEmpty) {
        //No value for this interval so retry
        emit(CronoStatePlay(
          progressIndex: progressIndex,
          duration: 0,
          hr: (state as CronoStateExt).hr,
          errorMessage: 'Empty interval, retry',
          battery: (state as CronoStateExt).battery,
        ));
      } else {
        progressIndex++;

        if (progressIndex == 5) {
          emit(CronoStateSaving());

          //end the session of data collection
          //print(polarToSave);
          await hrSubscription?.cancel(); //stop collecting heart data
          await bluePolar?.cancel();
          await batteryPolar?.cancel();
          await polar.disconnectFromDevice(polarIdentifier); //disconnect Polar

          int idSession = await db.sessionsDao.inserNewSession(
              SessionsCompanion(
                  iduser: Value(idUser),
                  numsession: Value(numSession),
                  startsession: polarToSave[0].first.timestamp,
                  endsession: polarToSave[status.length - 1].last.timestamp,
                  device1: Value(sessionDevices[0]),
                  device2: Value(sessionDevices[1])));

          for (int i = 0; i < polarToSave.length; i++) {
            int idInterv =
                await db.intervalsDao.inserNewInterval(IntervalsCompanion(
              //Save the new interval
              idSession: Value(idSession),
              runstatus: Value(i),
              startstimestamp: polarToSave[i].first.timestamp,
              endtimestamp: polarToSave[i].last.timestamp,
              deltatime: Value(polarToSave[i].last.timestamp.value -
                  polarToSave[i].first.timestamp.value),
            ));
            for (int j = 0; j < polarToSave[i].length; j++) {
              await db.polarRatesDao.insert(PolarRatesCompanion(
                idInterval: Value(idInterv),
                timestamp: polarToSave[i][j].timestamp,
                value: polarToSave[i][j].value,
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
            errorMessage: (state as CronoStateExt).errorMessage,
            battery: (state as CronoStateExt).battery,
          ));
        }
      }
    });

    on<CronoEventDelete>(
      (event, emit) {
        polarToSave[progressIndex].clear();
        emit(CronoStatePlay(
          progressIndex: progressIndex,
          duration: 0,
          hr: (state as CronoStateExt).hr,
          errorMessage: (state as CronoStateExt).errorMessage,
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
