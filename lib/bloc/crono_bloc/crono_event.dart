part of 'crono_bloc.dart';

abstract class CronoEvent extends Equatable {
  const CronoEvent();

  @override
  List<Object?> get props => [];
}

class CronoEventPlay extends CronoEvent {
  int duration;
  CronoEventPlay({required this.duration});

  @override
  List<Object> get props => [duration];
}

class CronoEventPause extends CronoEvent {
  String? errorMessage;
  CronoEventPause({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class CronoEventStop extends CronoEvent {}

class CronoEventSave extends CronoEvent {}

class CronoEventDelete extends CronoEvent {}

class CronoEventResume extends CronoEvent {}

class CronoEventDeleteSession extends CronoEvent {}

class CronoEventTicked extends CronoEvent {
  int duration;
  CronoEventTicked({required this.duration});
  @override
  List<Object> get props => [duration];
}
