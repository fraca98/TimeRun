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

  List<List<PolarRatesCompanion>> polarToSave =
      List.generate(status.length, (index) => []);

  CronoBloc({
    required this.polar,
    required int idUser,
    required List<String> sessionDevices,
    required int numSession,
  }) : super(CronoStateInit()) {
    polar.deviceDisconnectedStream.listen((event) {
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
            duration: state.duration,
            hr: 0,
            errorMessage: error));
      }
      if (state is CronoStateRunning) {
        add(CronoEventPause(errorMessage: error));
      }
      if (state is CronoStatePause) {
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: 0,
            errorMessage: error));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: state.duration,
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
            errorMessage: error));
      }
      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr,
            errorMessage: error));
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
              duration: state.duration,
              hr: event.data.hr));
        } else {
          add(CronoEventPause(errorMessage: error));
        }
      }

      if (state is CronoStatePause) {
        emit(CronoStatePause(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr,
            errorMessage: error));
      }
      if (state is CronoStateStop) {
        emit(CronoStateStop(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr,
            errorMessage: error));
      }
      if (state is CronoStateSaving) {
        //saving and complete should remove all {}
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
    });
    on<CronoEventPlay>((event, emit) {
      if (state.hr != 0) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: state.hr));

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
                duration: state.duration,
                hr: state.hr,
              ))
            : emit(CronoStatePause(
                progressIndex: progressIndex,
                duration: state.duration,
                hr: 0,
                errorMessage: event.errorMessage));
      },
    );

    on<CronoEventStop>((event, emit) {
      tickerSubscription?.cancel();
      state.errorMessage == null
          ? emit(CronoStateStop(
              progressIndex: progressIndex,
              duration: state.duration,
              hr: state.hr,
            ))
          : emit(CronoStateStop(
              progressIndex: progressIndex,
              duration: state.duration,
              hr: 0,
              errorMessage: state.errorMessage,
            ));

      /*print(polarToSave);
      if (polarToSave[progressIndex].isNotEmpty) {
        print(polarToSave[progressIndex].first);
        print(polarToSave[progressIndex].last);
      }*/
    });

    on<CronoEventResume>(
      (event, emit) {
        if (state.hr != 0) {
          tickerSubscription?.resume();
          emit(CronoStateRunning(
              progressIndex: progressIndex,
              duration: state.duration,
              hr: state.hr));
        }
      },
    );

    on<CronoEventSave>((event, emit) async {
      progressIndex++;

      if (progressIndex == 5) {
        //end the session of data collection
        print(polarToSave);
        hrSubscription!.cancel(); //stop collecting heart data
        polar.disconnectFromDevice(polarIdentifier); //disconnect Polar

        emit(CronoStateSaving(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));

        int idSession = await db.sessionsDao.inserNewSession(SessionsCompanion(
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
        polarToSave[progressIndex].clear();
        emit(CronoStatePlay(
            progressIndex: progressIndex, duration: 0, hr: state.hr));
      },
    );

    on<CronoEventDeleteSession>(
      (event, emit) async {
        hrSubscription!.cancel(); //stop collecting heart data
        polar.disconnectFromDevice(polarIdentifier); //disconnect polar
      },
    );

    on<CronoEventTicked>(
      (event, emit) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: state
                .hr)); //polar.list ultimo hr // una lista di polarratescompanion
      }, //metodi batch per inserire tutti insieme (documnetazione drift)
    );
  }

  @override
  Future<void> close() {
    hrSubscription?.cancel();
    tickerSubscription?.cancel();
    return super.close();
  }
}

/*introdurre listener se si stacca bluetooth
check se gli stati sono corretti in sequenza
sistemare salvataggio stati...*/

/*introdurre check 
-connessione bluetooth
-0 HR -> nocontact
-0HR -> Spento
*/
//meglio usare una snackbar (ex.saving, deleting ...)

//considerazioni su primo e ultimo timestamp: battito?

//In questo caso ho adottato: listen su CronoStateRunning per ogni evento con hr != 0
// quindi salvo un polar HR quando lo ascolto e sono in running (Non faccio considerazioni su play, stop , pause col valore precedente)