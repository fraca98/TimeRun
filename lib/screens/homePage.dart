import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/screens/detailPage.dart';
import '../bloc/user_bloc/user_bloc.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Utenti',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Text(
                'TimeRun',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 22),
              )),
              ListTile(
                onTap: () async {
                  Directory dbFolder = await getApplicationDocumentsDirectory();
                  final file = File('${dbFolder.path}/database.sqlite');
                  //print(file);
                  //print(file.path);
                  await GetIt.I<AppDatabase>()
                      .exportInto(file); // save the database (export) in local
                  await Share.shareFiles([file.path],
                      subject:
                          'TimeRun database'); //share the database file saved
                },
                title: Text('Esporta il database'),
                trailing: Icon(MdiIcons.shareVariant),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DriftDbViewer(GetIt.I<AppDatabase>())));
                },
                title: Text('Visualizza il database'),
                trailing: Icon(MdiIcons.databaseEye),
              )
            ],
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserStateLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UserStateLoaded) {
              return state.users.length == 0
                  ? Center(
                      child: Text(
                      'Non ci sono utenti',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                    ))
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 80),
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        Color color;
                        switch (state.users[index].completed) {
                          case 0:
                            color = Colors.red;
                            break;
                          case 1:
                            color = Colors.yellow;
                            break;
                          case 2:
                            color = Colors.green;
                            break;
                          default:
                            color = Colors.black;
                        }
                        return Card(
                          elevation: 8,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                            id: state.users[index].id,
                                          )));
                            },
                            leading: Icon(
                              state.users[index].sex
                                  ? MdiIcons.faceMan
                                  : MdiIcons.faceWoman,
                              color: color,
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
                  context.read<UserBloc>().add(UserEventAdd(
                          //TODO: remove, it's just an example to see if db works and BLOC
                          userComp: UsersCompanion(
                        name: Value(Random().nextInt(50).toString()),
                        surname: Value(Random().nextInt(50).toString()),
                        sex: Value(Random().nextBool()),
                      )));
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
