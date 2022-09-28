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
      emit(DetailStateLoaded(user: user));
    });

    add(DetailEventLoad(id: id)); // run when created class DetailBloc
  }
}
