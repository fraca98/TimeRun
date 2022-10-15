import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeStateLoading()) {
    AppDatabase db = GetIt.I<AppDatabase>(); //database getIt

    Stream<List<User>> streamUsers = db.usersDao.watchUsers();
    streamUsers.listen(
      (event) {
        emit(HomeStateLoaded(users: event));
      },
    );
  }
}
