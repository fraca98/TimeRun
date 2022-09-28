part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailStateLoading extends DetailState {}

class DetailStateLoaded extends DetailState {
  User user;
  DetailStateLoaded({required this.user});

  @override
  List<Object> get props => [user];
}