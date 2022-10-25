part of 'crono_bloc.dart';

abstract class CronoState extends Equatable {
  CronoState();

  @override
  List<Object?> get props => [];
}

class CronoStateExt extends CronoState {
  int progressIndex;
  int duration;
  int hr;
  String? errorMessage;
  CronoStateExt(
      {required this.progressIndex,
      required this.duration,
      required this.hr,
      this.errorMessage});

  @override
  List<Object?> get props => [progressIndex, duration, hr, errorMessage];
}

class CronoStateInit extends CronoState {
  CronoStateInit();
}

class CronoStatePlay extends CronoStateExt {
  CronoStatePlay(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.errorMessage});
}

class CronoStateRunning extends CronoStateExt {
  CronoStateRunning(
      {required super.progressIndex,
      required super.duration,
      required super.hr});
}

class CronoStatePause extends CronoStateExt {
  CronoStatePause(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.errorMessage});
}

class CronoStateStop extends CronoStateExt {
  CronoStateStop(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.errorMessage});
}

class CronoStateSaving extends CronoState {
  CronoStateSaving();
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted();
}
