import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/screens/datacollectionPage.dart';

import '../bloc/user_bloc/user_bloc.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static const route = '/user/';
  static const routename = 'UserPage';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final infoUser = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => alertDelete(infoUser));
              },
              icon: Icon(MdiIcons.delete))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Icon(
                    infoUser.sex ? MdiIcons.faceMan : MdiIcons.faceWoman,
                    color: Colors.red,
                    size: 150,
                  ),
                  Table(
                    border: TableBorder.all(),
                    defaultColumnWidth: FixedColumnWidth(100.0),
                    children: [
                      TableRow(children: [
                        Column(children: [Text('Nome')]),
                        Column(children: [Text(infoUser.name)]),
                      ]),
                      TableRow(children: [
                        Column(children: [Text('Cognome')]),
                        Column(children: [Text(infoUser.surname)]),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Divider(
              thickness: 1,
            ),
            ListTile(
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
                color: Colors.green,
              ),
              trailing: null,
            ),
            SizedBox(
              height: 50,
            ),
            ListTile(
              title: Text('Sessione 2'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Garmin'), Text('Fitbit')],
                ),
              ),
              leading: Icon(MdiIcons.circle),
              trailing: IconButton(
                icon: Icon(MdiIcons.play),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      DataCollectionPage.route, (_) => false);
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  // set up the AlertDialog when deleting user
  Widget alertDelete(User infoUser) {
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
              context.read<UserBloc>().add(UserEventDelete(id: infoUser.id));
              Navigator.of(context).pop();
            },
            child: Text(
              'Elimina',
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
  }
}
