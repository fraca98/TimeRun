part of 'introfitbit_bloc.dart';

abstract class IntroFitbitState extends Equatable {
  const IntroFitbitState();

  @override
  List<Object> get props => [];
}

class IntroFitbitInitial extends IntroFitbitState {}

class IntroFitbitLoading extends IntroFitbitState {}

class IntroFitbitLoaded extends IntroFitbitState {}

class IntroFitbitError extends IntroFitbitState {}
