part of 'download_bloc.dart';

abstract class DownloadState extends Equatable {
  DownloadState();

  @override
  List<Object?> get props => [];
}

class DownloadStateInitial extends DownloadState {}

class DownloadStateLoaded extends DownloadState {
  Session session;
  bool? error;
  DownloadStateLoaded({required this.session, this.error});

  @override
  List<Object?> get props => [session, error];
}

class DownloadStateLoading extends DownloadState {
  Session session;
  int numTile;
  DownloadStateLoading({required this.session, required this.numTile});

  @override
  List<Object> get props => [session, numTile];
}