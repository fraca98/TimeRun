part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class DetailEventLoad extends DetailEvent{
  final int id;
  DetailEventLoad({required this.id});

  @override 
  List<Object?> get props => [id];
}

class DetailEventDeleteUser extends DetailEvent{
  final int id;
  DetailEventDeleteUser({required this.id});

  @override
  List<Object> get props => [id];
}