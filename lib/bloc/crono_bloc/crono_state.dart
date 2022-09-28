part of 'crono_bloc.dart';

abstract class CronoState extends Equatable {
  int progressIndex;
  CronoState({required this.progressIndex});

  @override
  List<Object> get props => [];
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

class CronoStateLoading extends CronoState {
  CronoStateLoading({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}

class CronoStateCompleted extends CronoState {
  CronoStateCompleted({required super.progressIndex});

  @override
  List<Object> get props => [progressIndex];
}
