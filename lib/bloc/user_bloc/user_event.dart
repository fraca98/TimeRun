part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserEventLoad extends UserEvent {}

class UserEventAdd extends UserEvent {
  final UsersCompanion userComp; //use UsersCompanion cause autoincremental id (we can't set id)
  UserEventAdd({required this.userComp});

  @override
  List<Object> get props => [userComp];
}
