part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}



class DetailEventDeleteUser extends DetailEvent {
  int id;
  DetailEventDeleteUser({required this.id});
  @override
  List<Object> get props => [id];
}
