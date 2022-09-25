import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/database/userDao.dart';
import '../bloc/user_bloc/user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/home/';
  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserStateLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is UserStateLoaded) {
            return state.users.length == 0
                ? Center(child: Text('There are not users'))
                : ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 8,
                        child: ListTile(
                          leading: Icon(
                            state.users[index].sex ? MdiIcons.faceMan : MdiIcons.faceWoman,
                            color: Colors.red,
                          ),
                          title: Text(
                              '${state.users[index].name} ${state.users[index].surname}'),
                          subtitle:
                              Text(state.users[index].sex ? 'Uomo' : 'Donna'),
                          trailing: Icon(MdiIcons.arrowRight),
                        ),
                      );
                    },
                  );
          } else {
            return Text('Error UserBloc');
          }
        },
      ),
      floatingActionButton: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserStateLoaded) {
            return FloatingActionButton(
              child: Icon(MdiIcons.accountPlus),
              onPressed: () async {
                context.read<UserBloc>().add(UserEventAdd( //TODO: remove, it's just an example to see if db works and BLOC
                    userComp: UsersCompanion(
                        name: Value(Random().nextInt(50).toString()),
                        surname: Value(Random().nextInt(50).toString()),
                        sex: Value(Random().nextBool()))));
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
