part of 'introfitbit_bloc.dart';

abstract class IntroFitbitEvent extends Equatable {
  const IntroFitbitEvent();

  @override
  List<Object> get props => [];
}

class LoadIntroFitbitEvent extends IntroFitbitEvent {
} //press button to authorize
