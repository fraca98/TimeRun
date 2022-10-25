part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class DetailEventDeleteUser extends DetailEvent {}

class DetailEventDownload extends DetailEvent {
  int numSession;
  DetailEventDownload({required this.numSession}); //1 if session 1, 2 if session 2 (to know which session i'm considering to download data)

  @override
  List<Object?> get props => [numSession];
}
