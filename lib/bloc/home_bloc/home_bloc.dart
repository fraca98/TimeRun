import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  StreamSubscription? subUsers;
  HomeBloc() : super(HomeStateLoading()) {
    AppDatabase db = GetIt.I<AppDatabase>(); //database getIt

    Stream<List<User>> streamUsers = db.usersDao.watchUsers();
    subUsers = streamUsers.listen(
      (event) {
        emit(HomeStateLoaded(users: event));
      },
    );
  }

  @override
  Future<void> close() async {
    await subUsers?.cancel();
    return super.close();
  }
}
