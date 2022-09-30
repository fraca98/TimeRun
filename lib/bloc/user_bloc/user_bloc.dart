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
        //print('Loading Users from database');
        //await Future.delayed(Duration(seconds: 1));
        /*print(await db.usersDao.allEntries);
        print(await db.sessionsDao.allEntries);
        print(await db.intervalsDao.allEntries);*/
        emit(
          UserStateLoaded(users: await db.usersDao.allEntries),
        );
      },
    );

    on<UserEventAdd>(
      (event, emit) async {
        emit(UserStateLoading());
        await db.usersDao.insertNewUser(UsersCompanion(
          name: event.userComp.name,
          surname: event.userComp.surname,
          sex: event.userComp.sex,
        )); //TODO: Remove and add page with the form
        //print('Added a new User');
        emit(UserStateLoaded(
            users: await db.usersDao
                .allEntries)); //list of Users loaded from the db (cause User has now value id (autoid))
      },
    );

    add(UserEventLoad()); //event called when first use UserBloc
  }
}
