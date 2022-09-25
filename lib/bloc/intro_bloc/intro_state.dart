part of 'intro_bloc.dart';

abstract class IntroState extends Equatable{
  const IntroState();

  @override
  get props => [];
}

class IntroInitial extends IntroState {}

class IntroLoading extends IntroState{}

class IntroLoaded extends IntroState{}

class IntroError extends IntroState{}
