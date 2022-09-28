import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserStateLoading()) {
    AppDatabase db = GetIt.I<AppDatabase>(); //database getIt

    on<UserEventLoad>(
      (event, emit) async {
        print('Loading Users from database');
        //await Future.delayed(Duration(seconds: 1));
        emit(
          UserStateLoaded(users: await db.usersDao.allEntries),
        );
      },
    );

    on<UserEventAdd>(
      (event, emit) async {
        emit(UserStateLoading());
        print('Added a new User');
        await db.usersDao.insertNewUser(UsersCompanion(
            name: event.userComp.name,
            surname: event.userComp.surname,
            sex: event.userComp.sex,
            session: event.userComp.session)); //TODO: REMOVE
        emit(UserStateLoaded(
            users: await db.usersDao
                .allEntries)); //list of Users loaded from the db (cause User has now value id (autoid))
      },
    );

    on<UserEventDelete>(
      (event, emit) async {
        emit(UserStateLoading());
        print('Removed user');
        await db.usersDao.deleteUser(event.id);
        emit(UserStateLoaded(users: await db.usersDao.allEntries));
      },
    );

    add(UserEventLoad()); //event called when first use UserBloc
  }
}
