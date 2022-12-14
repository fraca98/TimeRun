import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/detail_bloc/detail_bloc.dart';
import 'package:timerun/model/device.dart';
import 'package:timerun/widget/alertsession.dart';
import '../database/AppDatabase.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(user),
      child: BlocConsumer<DetailBloc, DetailState>(
        listener: (context, state) {
          if (state is DetailStateDeletedUser) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is DetailStateDeletingUser ||
                  state is DetailStateDeletedUser ||
                  state is DetailStateDownloading) {
                return false;
              } else {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.pop(context);
                return false;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: state is DetailStateDeletingUser ||
                        state is DetailStateDeletedUser ||
                        state is DetailStateDownloading
                    ? false
                    : true,
                title: Text(
                  'User Detail',
                ),
                centerTitle: true,
                actions: [
                  state is DetailStateLoaded
                      ? IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            showDialog(
                              context: context,
                              builder: (_) {
                                return alertDelete(context,
                                    state); //here pass the context of the page (Not context of dialog)
                              },
                            );
                          },
                          icon: Icon(MdiIcons.delete))
                      : Container(),
                ],
              ),
              body: BlocConsumer<DetailBloc, DetailState>(
                listener: (context, state) {
                  if (state is DetailStateLoaded && state.message != null) {
                    state.message!.contains('Error')
                        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                            children: [
                              Icon(
                                MdiIcons.alertCircle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(state.message!),
                            ],
                          )))
                        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Row(
                              children: [
                                Icon(
                                  MdiIcons.fileExport,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(state.message!),
                              ],
                            )));
                  }
                },
                builder: (context, state) {
                  if (state is DetailStateDeletingUser ||
                      state is DetailStateDeletedUser) {
                    return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Deleting the user",
                            )
                          ]),
                    );
                  }
                  if (state is DetailStateLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is DetailStateLoaded ||
                      state is DetailStateDownloading) {
                    state = state as DetailStateExt;
                    return _body(context, state);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, DetailStateExt state) {
    Color colorFaceIcon;
    if (state.session1 != null && state.session2 != null) {
      colorFaceIcon = Colors.green;
    } else if (state.session1 == null && state.session2 == null) {
      colorFaceIcon = Colors.red;
    } else if (state.session1 != null && state.session2 == null) {
      colorFaceIcon = Colors.yellow;
    } else {
      colorFaceIcon = Colors.black;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Icon(
          user.sex == 1 ? MdiIcons.faceMan : MdiIcons.faceWoman,
          size: 150,
          color: colorFaceIcon,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Table(
            children: [
              TableRow(children: [
                Column(children: [
                  Text(
                    '#ID',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ]),
                Column(children: [
                  Text(
                    user.id.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ]),
              ]),
              TableRow(children: [
                //fake TableRow to add space
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                )
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                    'BirthYear',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ]),
                Column(children: [
                  Text(
                    user.birthYear.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ]),
              ]),
            ],
          ),
        ),
        Spacer(),
        Divider(
          thickness: 1,
        ),
        Container(
          height: 60,
          child: ListTile(
              title: Text(
                'Session 1',
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.session1 == null
                        ? [
                            Text(
                              'No Data',
                            )
                          ]
                        : [
                            Text(state.session1!.device1),
                            Text(state.session1!.device2)
                          ]),
              ),
              leading: Icon(
                MdiIcons.circle,
                color: state.session1 == null ? Colors.grey : Colors.green,
              ),
              trailing: state is DetailStateLoaded
                  ? state.session1 == null
                      ? IconButton(
                          icon: Icon(MdiIcons.play),
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  List<String> selectable = [...devices];
                                  return AlertSession(
                                    selectable: selectable,
                                    user: user,
                                  );
                                });
                          },
                        )
                      : state.session1!.download
                          ? IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                context
                                    .read<DetailBloc>()
                                    .add(DetailEventExport(numSession: 1));
                              },
                              icon: Icon(MdiIcons.shareVariant))
                          : IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                context
                                    .read<DetailBloc>()
                                    .add(DetailEventDownload(numSession: 1));
                              },
                              icon: Icon(MdiIcons.download))
                  : (state as DetailStateDownloading).downSession == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : null),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 60,
          child: ListTile(
            title: Text(
              'Session 2',
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.session2 == null
                      ? [
                          Text(
                            'No Data',
                          )
                        ]
                      : [
                          Text(
                            state.session2!.device1,
                          ),
                          Text(
                            state.session2!.device2,
                          )
                        ]),
            ),
            leading: Icon(
              MdiIcons.circle,
              color: state.session2 == null ? Colors.grey : Colors.green,
            ),
            trailing: state.session1 == null
                ? null
                : state is DetailStateLoaded
                    ? state.session2 == null
                        ? IconButton(
                            icon: Icon(MdiIcons.play),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    List<String> selectable = [...devices];
                                    selectable.remove(state.session1?.device1);
                                    selectable.remove(state.session1?.device2);
                                    return AlertSession(
                                      selectable: selectable,
                                      user: user,
                                    );
                                  });
                            },
                          )
                        : state.session2!.download
                            ? IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  context
                                      .read<DetailBloc>()
                                      .add(DetailEventExport(numSession: 2));
                                },
                                icon: Icon(MdiIcons.shareVariant))
                            : IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  context
                                      .read<DetailBloc>()
                                      .add(DetailEventDownload(numSession: 2));
                                },
                                icon: Icon(MdiIcons.download))
                    : (state as DetailStateDownloading).downSession == 2
                        ? CircularProgressIndicator()
                        : null,
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ]),
    );
  }

  // set up the AlertDialog when deleting user
  Widget alertDelete(BuildContext context, DetailStateLoaded state) {
    return AlertDialog(
      icon: Icon(MdiIcons.alert),
      title: Text("Warning"),
      content: Text(
        "Are you sure to delete this user?",
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
              context.read<DetailBloc>().add(
                  DetailEventDeleteUser()); //ok cause i pop first the dialog, so its context
            },
            child: Text(
              'Delete',
            ))
      ],
    );
  }
}
