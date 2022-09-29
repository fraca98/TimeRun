part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailStateLoading extends DetailState {}

class DetailStateLoaded extends DetailState {
  User user;
  Session? session1;
  Session? session2;
  DetailStateLoaded({required this.user, this.session1, this.session2});

  @override
  List<Object?> get props => [user, session1, session2];
}