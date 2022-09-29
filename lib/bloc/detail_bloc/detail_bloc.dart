import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(int id) : super(DetailStateLoading()) {
    AppDatabase db = GetIt.I<AppDatabase>();

    on<DetailEventLoad>((event, emit) async {
      emit(DetailStateLoading());
      User user = await db.usersDao.retrieveSpecificUser(event.id);
      print(user);

      Session? session1;
      Session? session2;

      if (user.session1 != null) {
        //retrieve session1
        session1 = await db.sessionsDao.retrieveSpecificSession(user.session1!);
        print(session1);
      }
      if (user.session2 != null) {
        //retrieve session2
        session2 = await db.sessionsDao.retrieveSpecificSession(user.session2!);
        print(session2);
      }

      emit(DetailStateLoaded(
          user: user, session1: session1, session2: session2));
    });

    add(DetailEventLoad(id: id)); // run when created class DetailBloc
  }
}
