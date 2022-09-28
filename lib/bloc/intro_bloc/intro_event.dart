part of 'intro_bloc.dart';

abstract class IntroEvent extends Equatable {
  const IntroEvent();

  @override
  List<Object> get props => [];
}

class LoadIntroEvent extends IntroEvent {} //press button to authorize

class FinishIntroEvent extends IntroEvent{} // press button end intro

