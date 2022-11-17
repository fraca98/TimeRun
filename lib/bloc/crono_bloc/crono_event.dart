part of 'crono_bloc.dart';

abstract class CronoEvent extends Equatable {
  const CronoEvent();

  @override
  List<Object?> get props => [];
}

class CronoEventPlay extends CronoEvent {
  final int duration;
  CronoEventPlay({required this.duration});

  @override
  List<Object> get props => [duration];
}

class CronoEventPause extends CronoEvent {
  final String? message;
  CronoEventPause({this.message});

  @override
  List<Object?> get props => [message];
}

class CronoEventStop extends CronoEvent {}

class CronoEventSave extends CronoEvent {}

class CronoEventDelete extends CronoEvent {}

class CronoEventResume extends CronoEvent {}

class CronoEventDeleteSession extends CronoEvent {}

class CronoEventTicked extends CronoEvent {
  final int duration;
  CronoEventTicked({required this.duration});
  @override
  List<Object> get props => [duration];
}
