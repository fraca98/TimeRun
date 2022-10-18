part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailStateLoading extends DetailState {}

class DetailStateLoaded extends DetailState {
  Session? session1;
  Session? session2;
  
  DetailStateLoaded({this.session1, this.session2});

  @override
  List<Object?> get props => [session1, session2];
}

class DetailStateDeletingUser extends DetailState {} //deleting user

class DetailStateDeletedUser extends DetailState {} //user deleted
