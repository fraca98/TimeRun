import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/detail_bloc/detail_bloc.dart';
import 'package:timerun/model/device.dart';
import 'package:timerun/widget/alertsession.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(id),
      child: BlocConsumer<DetailBloc, DetailState>(
        listener: (context, state) {
          if (state is DetailStateDeletedUser) {
            Navigator.pop(context, true); //pass true if pop and delete the user
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is DetailStateDeletingUser ||
                  state is DetailStateDeletedUser) {
                return false;
              } else {
                Navigator.pop(context, BlocProvider.of<DetailBloc>(context).hasnewsession);
                return false;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: state is DetailStateDeletingUser ||
                        state is DetailStateDeletingUser
                    ? false
                    : true,
                title: Text('Dettagli utente',
                    style: TextStyle(fontFamily: 'Poppins')),
                centerTitle: true,
                actions: [
                  state is DetailStateLoaded
                      ? IconButton(
                          onPressed: () {
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
              body: BlocBuilder<DetailBloc, DetailState>(
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
                              "Cancello l'utente",
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            )
                          ]),
                    );
                  }
                  if (state is DetailStateLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is DetailStateLoaded) {
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

  Widget _body(BuildContext context, DetailStateLoaded state) {
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
          state.user.sex ? MdiIcons.faceMan : MdiIcons.faceWoman,
          size: 150,
          color: colorFaceIcon,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Table(
            //border: TableBorder.all(),
            children: [
              TableRow(children: [
                Column(children: [
                  Text(
                    'Nome',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                  )
                ]),
                Column(children: [
                  Text(state.user.name,
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                    'Cognome',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                  )
                ]),
                Column(children: [
                  Text(state.user.surname,
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                    'Sesso',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                  )
                ]),
                Column(children: [
                  Text(state.user.sex ? 'Uomo' : 'Donna',
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'))
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
            title: Text('Sessione 1', style: TextStyle(fontFamily: 'Poppins')),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.session1 == null
                      ? [
                          Text('No Data',
                              style: TextStyle(fontFamily: 'Poppins'))
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
            trailing: state.session1 == null
                ? IconButton(
                    icon: Icon(MdiIcons.play),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            List<String> selectable = [...devices];
                            return AlertSession(
                              supercontext:
                                  context, //pass this context to use the DetailBloc in the alertdialog of session
                              selectable: selectable,
                              id: id,
                            );
                          });
                    },
                  )
                : null,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 60,
          child: ListTile(
            title: Text(
              'Sessione 2',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.session2 == null
                      ? [
                          Text('No Data',
                              style: TextStyle(fontFamily: 'Poppins'))
                        ]
                      : [
                          Text(state.session2!.device1,
                              style: TextStyle(fontFamily: 'Poppins')),
                          Text(state.session2!.device2,
                              style: TextStyle(fontFamily: 'Poppins'))
                        ]),
            ),
            leading: Icon(
              MdiIcons.circle,
              color: state.session2 == null ? Colors.grey : Colors.green,
            ),
            trailing: state.session1 == null || state.session2 != null
                ? null
                : IconButton(
                    icon: Icon(MdiIcons.play),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            List<String> selectable = [...devices];
                            selectable.remove(state.session1?.device1);
                            selectable.remove(state.session1?.device2);
                            return AlertSession(
                              supercontext:
                                  context, //pass this context to use the DetailBloc in the alertdialog of session
                              selectable: selectable,
                              id: id,
                            );
                          });
                    },
                  ),
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
      title: Text("Attenzione", style: TextStyle(fontFamily: 'Poppins')),
      content: Text("Sei sicuro di voler eliminare questo utente ?",
          style: TextStyle(fontFamily: 'Poppins')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annulla', style: TextStyle(fontFamily: 'Poppins')),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<DetailBloc>().add(DetailEventDeleteUser(id: id)); //ok cause i pop first the dialog, so its context
            },
            child: Text('Elimina', style: TextStyle(fontFamily: 'Poppins')))
      ],
    );
  }
}
