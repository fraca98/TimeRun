import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/home_bloc/home_bloc.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/screens/detailPage.dart';
import 'package:timerun/screens/formUserPage.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Users',
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    child: CircleAvatar(
                  child: Image.asset('assets/timerunlogo.png'),
                  backgroundColor: Colors.transparent,
                )),
                ListTile(
                  onTap: () async {
                    context.read<HomeBloc>().add(HomeEventExportDB());
                  },
                  title: Text('Export the database'),
                  trailing: Icon(MdiIcons.shareVariant),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DriftDbViewer(GetIt.I<AppDatabase>())));
                  },
                  title: Text('Visualize the database'),
                  trailing: Icon(MdiIcons.databaseEye),
                )
              ],
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeStateLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is HomeStateLoaded) {
                return state.users.length == 0
                    ? Center(
                        child: Text(
                        'There are not users',
                        style: TextStyle(fontSize: 18),
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
                                              user: state.users[index],
                                            )));
                              },
                              leading: Icon(
                                state.users[index].sex == 1
                                    ? MdiIcons.faceMan
                                    : MdiIcons.faceWoman,
                                color: color,
                              ),
                              title: Text('${state.users[index].id}'),
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
          floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeStateLoaded) {
                return FloatingActionButton(
                  child: Icon(MdiIcons.accountPlus),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FormUserPage()));
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        );
      }),
    );
  }
}
