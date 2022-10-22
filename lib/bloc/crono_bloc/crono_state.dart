part of 'crono_bloc.dart';

abstract class CronoState extends Equatable {
  int progressIndex;
  int duration;
  int hr;
  String? errorMessage;
  CronoState(
      {required this.progressIndex,
      required this.duration,
      required this.hr,
      this.errorMessage});

  @override
  List<Object?> get props => [progressIndex, duration, hr, errorMessage];
}

class CronoStateInit extends CronoState {
  CronoStateInit({super.progressIndex = 0, super.duration = 0, super.hr = 0});
}

class CronoStatePlay extends CronoState {
  CronoStatePlay(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.errorMessage});
}

class CronoStateRunning extends CronoState {
  CronoStateRunning(
      {required super.progressIndex,
      required super.duration,
      required super.hr});
}

class CronoStatePause extends CronoState {
  CronoStatePause(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.errorMessage});
}

class CronoStateStop extends CronoState {
  CronoStateStop(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.errorMessage});
}

class CronoStateSaving extends CronoState {
  CronoStateSaving(
      {required super.progressIndex,
      required super.duration,
      required super.hr});
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted(
      {required super.progressIndex,
      required super.duration,
      required super.hr});
}
