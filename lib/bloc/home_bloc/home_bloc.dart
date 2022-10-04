import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeStateLoading()) {
    AppDatabase db = GetIt.I<AppDatabase>(); //database getIt

    on<HomeEventLoad>(
      (event, emit) async {
        //print('Loading Users from database');
        //await Future.delayed(Duration(seconds: 1));
        /*print(await db.usersDao.allEntries);
        print(await db.sessionsDao.allEntries);
        print(await db.intervalsDao.allEntries);*/
        emit(
          HomeStateLoaded(users: await db.usersDao.allEntries),
        );
      },
    );

    add(HomeEventLoad()); //event called when first use UserBloc
  }
}
