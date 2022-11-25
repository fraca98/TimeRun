part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeStateLoading extends HomeState {} //show loading from db

class HomeStateLoaded extends HomeState {
  //show list of users of db
  final List<User> users;
  HomeStateLoaded({required this.users});

  @override
  List<Object> get props => [users];
}
