part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadEventDownload extends DownloadEvent {
  int numTile;
  DownloadEventDownload({required this.numTile});

  @override
  List<Object> get props => [numTile];
}