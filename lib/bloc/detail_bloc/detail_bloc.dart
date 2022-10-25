import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/model/device.dart';
part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  AppDatabase db = GetIt.I<AppDatabase>();
  StreamSubscription? subStreamSession;
  DetailBloc(int id) : super(DetailStateLoading()) {
    Stream<List<Session>> streamSession = db.sessionsDao.watchSessionUser(id);

    subStreamSession = streamSession.listen((event) async {
      if (event.isEmpty) {
        emit(DetailStateLoaded(session1: null, session2: null));
      } else if (event.length == 1) {
        emit(DetailStateLoaded(session1: event[0], session2: null));
      } else if (event.length == 2) {
        emit(DetailStateLoaded(session1: event[0], session2: event[1]));
      } else {}
    });

    on<DetailEventDeleteUser>(
      (event, emit) async {
        emit(DetailStateDeletingUser());
        await db.usersDao
            .deleteUser(id); //on cascade deletes linked Sessions, Intervals
        //print('Removed user');
        emit(DetailStateDeletedUser());
      },
    );

    on<DetailEventDownload>(
      (event, emit) async {
        print('Pressed download');
        emit(DetailStateDownloading(
            session1: (state as DetailStateLoaded).session1,
            session2: (state as DetailStateLoaded).session2,
            downSession: event.numSession));

        if (event.numSession == 1) {
          if ((state as DetailStateDownloading).session1!.device1 ==
                  devices[0] ||
              (state as DetailStateDownloading).session1!.device2 ==
                  devices[0]) {} //Fitbit
          if ((state as DetailStateDownloading).session1!.device1 ==
                  devices[1] ||
              (state as DetailStateDownloading).session1!.device2 ==
                  devices[1]) {} //Withings

        } else {
          if ((state as DetailStateDownloading).session2!.device1 ==
                  devices[0] ||
              (state as DetailStateDownloading).session2!.device2 ==
                  devices[0]) {} //Fitbit
          if ((state as DetailStateDownloading).session2!.device1 ==
                  devices[1] ||
              (state as DetailStateDownloading).session2!.device2 ==
                  devices[1]) {} //Withings

        }

        await Future.delayed(Duration(seconds: 3));
        emit(DetailStateLoaded(
            session1: (state as DetailStateDownloading).session1,
            session2: (state as DetailStateDownloading).session2));
      },
    );
  }
  @override
  Future<void> close() {
    subStreamSession?.cancel();
    return super.close();
  }
}

_withingsDownload() {}

_fitbitDownload() {}
