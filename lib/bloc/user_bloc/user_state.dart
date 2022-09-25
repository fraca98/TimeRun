part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserStateLoading extends UserState {} //show loading from db

class UserStateLoaded extends UserState {
  //show list of users of db
  final List<User> users;
  UserStateLoaded({required this.users});

  @override
  List<Object> get props => [users];
}