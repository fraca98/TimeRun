part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailStateLoading extends DetailState {}

class DetailStateExt extends DetailState {
  final Session? session1;
  final Session? session2;

  DetailStateExt({this.session1, this.session2});

  @override
  List<Object?> get props => [session1, session2];
}

class DetailStateLoaded extends DetailStateExt {
  final String? message;
  DetailStateLoaded({super.session1, super.session2, this.message});

  @override
  List<Object?> get props => [
        session1,
        session2,
        message,
        identityHashCode(this)
      ]; //identity hash code so i can re-emit the state even if i have the same message when exporting (cause else same state)
}

class DetailStateDeletingUser extends DetailState {} //deleting user

class DetailStateDeletedUser extends DetailState {} //user deleted

class DetailStateDownloading extends DetailStateExt {
  final int downSession;
  DetailStateDownloading(
      {super.session1, super.session2, required this.downSession});

  @override
  List<Object?> get props => [session1, session2, downSession];
}