import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timerun/screens/datacollectionPage.dart';
import 'package:timerun/screens/registrationpage.dart';

import '../providers/datacollectionprovider.dart';

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
            child: ListTile(
              leading: Icon(
                MdiIcons.accountCircle,
                color: Colors.red,
              ),
              title: Text('Mario Rossi'),
              subtitle: Text('No data'),
              trailing: Icon(MdiIcons.arrowRight),
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
                  Provider.of<DataCollectionProvider>(context, listen: false)
                      .resetProgressindex();
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
