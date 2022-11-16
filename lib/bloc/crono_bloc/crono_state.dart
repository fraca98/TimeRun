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
  String? message;
  int? battery;
  CronoStateExt(
      {required this.progressIndex,
      required this.duration,
      required this.hr,
      this.message,
      required this.battery});

  @override
  List<Object?> get props =>
      [progressIndex, duration, hr, message, battery];
}

class CronoStateInit extends CronoState {
  int? battery;
  CronoStateInit({this.battery});
   @override
  List<Object?> get props =>
      [battery];
}

class CronoStatePlay extends CronoStateExt {
  CronoStatePlay(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      required super.message,
      super.battery});
}

class CronoStateRunning extends CronoStateExt {
  CronoStateRunning(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      super.message,
      super.battery});
}

class CronoStatePause extends CronoStateExt {
  CronoStatePause(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      required super.message,
      super.battery});
}

class CronoStateStop extends CronoStateExt {
  CronoStateStop(
      {required super.progressIndex,
      required super.duration,
      required super.hr,
      required super.message,
      super.battery});
}

class CronoStateSaving extends CronoState {
  CronoStateSaving();
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted();
}
