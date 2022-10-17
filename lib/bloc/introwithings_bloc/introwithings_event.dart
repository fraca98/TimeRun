part of 'introwithings_bloc.dart';

abstract class IntroWithingsEvent extends Equatable {
  const IntroWithingsEvent();

  @override
  List<Object> get props => [];
}

class LoadIntroWithingsEvent extends IntroWithingsEvent {} //press button to authorize

