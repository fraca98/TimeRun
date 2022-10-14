import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  bool hasnewsession = false;
  DetailBloc(int id) : super(DetailStateLoading()) {
    AppDatabase db = GetIt.I<AppDatabase>();
    on<DetailEventLoad>((event, emit) async {
      User user = await db.usersDao.retrieveSpecificUser(event.id);
      if (state is DetailStateLoaded &&
          (state as DetailStateLoaded).user.completed != user.completed) {
        hasnewsession = true;
      }
      //emit(DetailStateLoading());
      //print(user);

      Session? session1;
      Session? session2;
      if (user.completed == 1) {
        session1 = await db.sessionsDao.retrieveSpecificSession(event.id, 1);
      }
      if (user.completed == 2) {
        session1 = await db.sessionsDao.retrieveSpecificSession(event.id, 1);
        session2 = await db.sessionsDao.retrieveSpecificSession(event.id, 2);
      }

      //print(session1);
      //print(session2);

      emit(DetailStateLoaded(
          user: user, session1: session1, session2: session2));
    });

    on<DetailEventDeleteUser>(
      (event, emit) async {
        emit(DetailStateDeletingUser());
        await db.usersDao.deleteUser(
            event.id); //on cascade deletes linked Sessions, Intervals
        //print('Removed user');
        emit(DetailStateDeletedUser());
      },
    );

    add(DetailEventLoad(id: id)); // run when created class DetailBloc
  }
}
