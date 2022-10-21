import 'dart:async';
import 'package:async/async.dart' show StreamGroup;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:polar/polar.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/device.dart';
import 'package:timerun/model/ticker.dart';
part 'crono_event.dart';
part 'crono_state.dart';

class CronoBloc extends Bloc<CronoEvent, CronoState> {
  int? starttimestamp;
  int? endtimestamp;
  int? idSession;
  AppDatabase db = GetIt.I<AppDatabase>();
  int progressIndex = 0;

  Polar polar;

  Ticker ticker = Ticker();
  StreamSubscription<int>? tickerSubscription;
  StreamSubscription? hrSubscription;

  List<List<PolarRatesCompanion>>? polarToSave;

  CronoBloc({
    required this.polar,
    required int idUser,
    required List<String> sessionDevices,
    required int numSession,
  }) : super(CronoStateInit()) {
    polar.deviceDisconnectedStream.listen((event) {
      print('Disconnesso dal bluetooth');
      if(state is CronoStateInit){

      }
      if (state is CronoStateRunning) {
        add(CronoEventPause());
      }
    });

    hrSubscription = polar.heartRateStream.listen((event) {
      print('Polar HR: ${event.data.hr}');
      if (event.data.hr == 0) {
        //polar shut down or no contact
        if (state is CronoStateRunning) {
          add(CronoEventPause());
        }
        print('Polar spento o no contact');
      }

      if (state is CronoStateInit) {
        emit(CronoStatePlay(
            progressIndex: progressIndex, duration: 0, hr: event.data.hr));
      }
// toglie il resto e aggiorna la lista della classe (Polar --> Classe Polar(timestamp, valore))
      if (state is CronoStatePlay) {
        emit(CronoStatePlay(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStateRunning) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: event.data.hr));
      }
      if (state is CronoStatePause) {
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
    on<CronoEventPlay>((event, emit) {
      if (state.hr != 0) {
        emit(CronoStateRunning(
            progressIndex: progressIndex,
            duration: event.duration,
            hr: state.hr));

        starttimestamp = null;
        endtimestamp = null;

        starttimestamp =
            (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor();
        //print('starttimestamp: $starttimestamp');

        tickerSubscription?.cancel();
        tickerSubscription = ticker
            .tick(ticks: event.duration)
            .listen((duration) => add(CronoEventTicked(duration: duration)));
      }
    });

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

      /*print(polarTimestamp);
      print(polarValue);
      print(starttimestamp);
      print(endtimestamp);*/
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
      emit(CronoStateSaving(
          progressIndex: progressIndex,
          duration: state.duration,
          hr: state.hr));

      progressIndex++;

      if (progressIndex == 5) {
        //end the session of data collection

        hrSubscription!.cancel(); //stop collecting heart data
        polar.disconnectFromDevice(polarIdentifier); //disconnect Polar
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
      },
    );

    on<CronoEventDeleteSession>(
      (event, emit) async {
        emit(CronoStateDeletingSession(
            progressIndex: progressIndex,
            duration: state.duration,
            hr: state.hr));

        starttimestamp = null;
        endtimestamp = null;

        hrSubscription!.cancel(); //stop collecting heart data
        polar.disconnectFromDevice(polarIdentifier); //disconnect polar
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
            hr: state
                .hr)); //polar.list ultimo hr // una lista di polarratescompanion
      }, //metodi batch per inserire tutti insieme (documnetazione drift)
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}


/* sistemare bloc timer
salvare dati solo alla fine
lista di polarcompanion da salvare alla fine -> companion o metti nullable id auto
*/

/*introdurre listener se si stacca bluetooth
check se gli stati sono corretti in sequenza
sistemare salvataggio stati...*/

/*introdurre check 
-connessione bluetooth
-0 HR -> nocontact
-0HR -> Spento
*/
//meglio usare una snackbar (ex.saving, deleting ...)