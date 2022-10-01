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

    add(UserEventLoad()); //event called when first use UserBloc
  }
}
