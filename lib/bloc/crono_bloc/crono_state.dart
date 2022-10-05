part of 'crono_bloc.dart';

abstract class CronoState extends Equatable {
  int progressIndex;
  int duration;
  CronoState({required this.progressIndex, required this.duration});

  @override
  List<Object> get props => [progressIndex, duration];
}

class CronoStatePlay extends CronoState {
  CronoStatePlay({required super.progressIndex, required super.duration});
}

class CronoStateRunning extends CronoState {
  CronoStateRunning({required super.progressIndex, required super.duration});
}

class CronoStatePause extends CronoState {
  CronoStatePause({required super.progressIndex, required super.duration});
}

class CronoStateStop extends CronoState {
  CronoStateStop({required super.progressIndex, required super.duration});
}

class CronoStateSaving extends CronoState {
  CronoStateSaving({required super.progressIndex, required super.duration});
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted({required super.progressIndex, required super.duration});
}

class CronoStateDeletingSession extends CronoState {
  CronoStateDeletingSession(
      {required super.progressIndex, required super.duration});
}

class CronoStateDeletedSession extends CronoState {
  CronoStateDeletedSession(
      {required super.progressIndex, required super.duration});
}
