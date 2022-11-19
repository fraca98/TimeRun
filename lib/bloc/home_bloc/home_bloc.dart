import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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

    on<HomeEventExportDB>(
      (event, emit) async {
        final path = (await getApplicationDocumentsDirectory()).path;
        final file = File('$path/database.sqlite');
        //debugPrint(file.toString());
        //debugPrint(file.path);
        await GetIt.I<AppDatabase>()
            .exportInto(file); // save the database (export) in local
        await Share.shareXFiles([XFile(file.path)],
            subject: 'TimeRun database', text: 'Date: ${DateTime.now()}'); //share the database file saved
      },
    );
  }

  @override
  Future<void> close() async {
    await subUsers?.cancel();
    return super.close();
  }
}
