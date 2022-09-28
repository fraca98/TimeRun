import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/detail_bloc/detail_bloc.dart';
import 'package:timerun/model/device.dart';
import 'package:timerun/screens/datacollectionPage.dart';
import '../bloc/user_bloc/user_bloc.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(id),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dettagli'),
          actions: [
            BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is DetailStateLoaded) {
                  return IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                alertDelete(context, state));
                      },
                      icon: Icon(MdiIcons.delete));
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
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
  }

  Widget _body(BuildContext context, DetailStateLoaded state) {
    Color colorFaceIcon;
    switch (state.user.session) {
      case 0:
        colorFaceIcon = Colors.red;
        break;
      case 1:
        colorFaceIcon = Colors.yellow;
        break;
      case 2:
        colorFaceIcon = Colors.green;
        break;
      default:
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
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                Column(children: [
                  Text(state.user.name, style: TextStyle(fontSize: 20))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                    'Cognome',
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                Column(children: [
                  Text(state.user.surname, style: TextStyle(fontSize: 20))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                    'Sesso',
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                Column(children: [
                  Text(state.user.sex ? 'Uomo' : 'Donna',
                      style: TextStyle(fontSize: 20))
                ]),
              ]),
              TableRow(children: [
                //TODO: remove this tablerow
                Column(children: [
                  Text(
                    'Session',
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                Column(children: [Text(state.user.session.toString())]),
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
            title: Text('Sessione 1'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Withings'), Text('Apple watch')],
              ),
            ),
            leading: Icon(
              MdiIcons.circle,
              color: state.user.session == 0 ? Colors.grey : Colors.green,
            ),
            trailing: state.user.session == 0
                ? IconButton(
                    icon: Icon(MdiIcons.play),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              alertSession(context));
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
            title: Text('Sessione 2'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Garmin'), Text('Fitbit')],
              ),
            ),
            leading: Icon(
              MdiIcons.circle,
              color: state.user.session < 2 ? Colors.grey : Colors.green,
            ),
            trailing: state.user.session < 1 || state.user.session == 2
                ? null
                : IconButton(
                    icon: Icon(MdiIcons.play),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => DataCollectionPage(
                                    id: id,
                                  ))),
                          (_) => false);
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
      title: Text("Attenzione"),
      content: Text("Sei sicuro di voler eliminare questo utente ?"),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annulla'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserBloc>().add(UserEventDelete(id: state.user.id));
              Navigator.of(context).pop();
            },
            child: Text(
              'Elimina',
            ))
      ],
    );
  }

  // dialogue per l'inizio della sessione 1 dove seleziono i device
  Widget alertSession(BuildContext context) {
    List<bool> togglecheck = List.generate(devices.length, (index) => false);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Seleziona i 2 dispositivi per la sessione',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(
              children: List.generate(
                devices.length,
                (index) => CheckboxListTile(
                  value: togglecheck[index],
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(devices[index]),
                  onChanged: (bool? value) {
                    setState(
                      () {
                        togglecheck[index] = value!;
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla')),
          togglecheck
                      .where(
                        (element) => element == true,
                      )
                      .length ==
                  2
              ? TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataCollectionPage(
                                  id: id,
                                )),
                        (_) => false);
                  },
                  child: Text('Inizia la sessione'))
              : Container(),
        ],
      );
    });
  }
}
