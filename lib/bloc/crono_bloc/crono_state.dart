part of 'crono_bloc.dart';

abstract class CronoState extends Equatable {
  int progressIndex;
  CronoState({required this.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStatePlay extends CronoState {
  CronoStatePlay({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateRunning extends CronoState {
  CronoStateRunning({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStatePause extends CronoState {
  CronoStatePause({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateStop extends CronoState {
  CronoStateStop({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateSaving extends CronoState {
  CronoStateSaving({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateDeletingSession extends CronoState {
  CronoStateDeletingSession({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateDeletedSession extends CronoState {
  CronoStateDeletedSession({required super.progressIndex});
  
  @override
  List<Object> get props => [progressIndex];
}