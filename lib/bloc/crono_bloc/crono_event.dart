part of 'crono_bloc.dart';

abstract class CronoEvent extends Equatable {
  const CronoEvent();

  @override
  List<Object> get props => [];
}

class CronoEventPlay extends CronoEvent {}

class CronoEventPause extends CronoEvent {}

class CronoEventStop extends CronoEvent {}

class CronoEventSave extends CronoEvent {}

class CronoEventDelete extends CronoEvent{}

class CronoEventResume extends CronoEvent{}