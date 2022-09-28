import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'crono_event.dart';
part 'crono_state.dart';

class CronoBloc extends Bloc<CronoEvent, CronoState> {
  int progressIndex;

  CronoBloc({this.progressIndex = 0})
      : super(CronoStatePlay(progressIndex: progressIndex)) {
    on<CronoEventPlay>(
      (event, emit) {
        emit(CronoStateRunning(progressIndex: progressIndex));
      },
    );

    on<CronoEventPause>(
      (event, emit) {
        emit(CronoStatePause(progressIndex: progressIndex));
      },
    );

    on<CronoEventStop>((event, emit) {
      emit(CronoStateStop(progressIndex: progressIndex));
    });

    on<CronoEventResume>(
      (event, emit) {
        emit(CronoStateRunning(progressIndex: progressIndex));
      },
    );

    on<CronoEventSave>((event, emit) async {
      emit(CronoStateLoading(progressIndex: progressIndex));
      // TODO: database stuff
      await Future.delayed(Duration(seconds: 1));
      progressIndex++;
      print(progressIndex);

      if (progressIndex == 5) {
        emit(CronoStateCompleted(progressIndex: progressIndex));
      }
      else{
        emit(CronoStatePlay(progressIndex: progressIndex));
      }
    });

    on<CronoEventDelete>(
      (event, emit) {
        emit(CronoStatePlay(progressIndex: progressIndex));
      },
    );
  }
}
