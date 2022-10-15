part of 'crono_bloc.dart';

abstract class CronoState extends Equatable {
  int progressIndex;
  int duration;
  int hr;
  CronoState({required this.progressIndex, required this.duration, required this.hr});

  @override
  List<Object> get props => [progressIndex, duration, hr];
}

class CronoStateInit extends CronoState{
  CronoStateInit({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStatePlay extends CronoState {
  CronoStatePlay({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStateRunning extends CronoState {
  CronoStateRunning({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStatePause extends CronoState {
  CronoStatePause({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStateStop extends CronoState {
  CronoStateStop({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStateSaving extends CronoState {
  CronoStateSaving({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted({required super.progressIndex, required super.duration, required super.hr});
}

class CronoStateDeletingSession extends CronoState {
  CronoStateDeletingSession(
      {required super.progressIndex, required super.duration, required super.hr});
}

class CronoStateDeletedSession extends CronoState {
  CronoStateDeletedSession(
      {required super.progressIndex, required super.duration, required super.hr});
}
