part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailStateLoading extends DetailState {}

class DetailStateExt extends DetailState {
  Session? session1;
  Session? session2;

  DetailStateExt({this.session1, this.session2});

  @override
  List<Object?> get props => [session1, session2];
}

class DetailStateLoaded extends DetailStateExt {
  bool? error;
  DetailStateLoaded({super.session1, super.session2, this.error});

  @override
  List<Object?> get props => [session1, session2, error];
}

class DetailStateDeletingUser extends DetailState {} //deleting user

class DetailStateDeletedUser extends DetailState {} //user deleted

class DetailStateDownloading extends DetailStateExt {
  int downSession;
  DetailStateDownloading(
      {super.session1, super.session2, required this.downSession});

  @override
  List<Object?> get props => [session1, session2, downSession];
}
