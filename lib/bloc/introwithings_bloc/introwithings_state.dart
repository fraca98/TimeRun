part of 'introwithings_bloc.dart';

abstract class IntroWithingsState extends Equatable{
  const IntroWithingsState();

  @override
  get props => [];
}

class IntroWithingsInitial extends IntroWithingsState {}

class IntroWithingsLoading extends IntroWithingsState{}

class IntroWithingsLoaded extends IntroWithingsState{}

class IntroWithingsError extends IntroWithingsState{}
