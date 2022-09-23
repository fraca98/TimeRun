import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/screens/datacollectionPage.dart';
import 'package:timerun/screens/registrationpage.dart';

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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          return Card(
            elevation: 8,
            child: Dismissible(
              key: ValueKey(index),
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.centerRight,
                color: Colors.redAccent,
                child: Icon(
                  MdiIcons.delete,
                  color: Colors.white,
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Attenzione"),
                      content:
                          Text("Sei sicuro di voler eliminare questo utente?"),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Elimina")),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Annulla"),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                print('Elimina utente');
              },
              child: ListTile(
                leading: Icon(MdiIcons.accountCircle),
                title: Text('Mario Rossi'),
                subtitle: Text('No data'),
                trailing: Icon(MdiIcons.arrowRight),
              ),
            ),
          );
        }),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, DataCollectionPage.route);
                },
                child: Text('Raccolgo dati')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.accountPlus),
        onPressed: () {
          Navigator.pushReplacementNamed(context, RegistrationPage.route);
        },
      ),
    );
  }
}
