import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerun/screens/bluetoothPage.dart';
import '../bloc/detail_bloc/detail_bloc.dart';
import '../screens/datacollectionPage.dart';

class AlertSession extends StatefulWidget { //Dialog alert session when start
  var selectable;
  int id;
  BuildContext supercontext;

  AlertSession(
      {super.key,
      required this.selectable,
      required this.id,
      required this.supercontext});

  @override
  State<AlertSession> createState() => _AlertSessionState();
}

class _AlertSessionState extends State<AlertSession> {
  late List<bool> togglecheck;

  @override
  void initState() {
    togglecheck = List.generate(widget.selectable.length,
        (index) => false); //only first time assing togglecheck value
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //rebuild with setstate()
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select the 2 devices for this session',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins'),
          ),
          Column(
            children: List.generate(
              widget.selectable.length,
              (index) => CheckboxListTile(
                value: togglecheck[index],
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(widget.selectable[index]),
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
            child: Text('Cancel', style: TextStyle(fontFamily: 'Poppins'))),
        togglecheck
                    .where(
                      (element) => element == true,
                    )
                    .length ==
                2
            ? TextButton(
                onPressed: () async {
                  int numSession;
                  togglecheck.length > 2 ? numSession = 1 : numSession = 2;
                  List<String> sessionDevices = [];
                  for (int i = 0; i < togglecheck.length; i++) {
                    if (togglecheck[i] == true) {
                      sessionDevices.add(widget.selectable[
                          i]); //get the devices toggled by user in previous screen
                    }
                  }
                  var reload = await Navigator.pushReplacement(
                      //replace: so if pop i don't go back to the dialogue
                      context,
                      MaterialPageRoute(
                        builder: (context) => BluetoothPage(id: widget.id, numSession: numSession, sessionDevices: sessionDevices,) //TODO: fix
                      ));
                  //print(widget.supercontext); //supercontext: NOT the context of the dialogue to pass to use DetailBloc
                  //print(reload);
                  if (reload != null && reload == true) {
                    widget.supercontext //pass supercontext to the bloc
                        .read<DetailBloc>()
                        .add(DetailEventLoad(id: widget.id));
                  }
                },
                child: Text('Start',
                    style: TextStyle(fontFamily: 'Poppins')))
            : Container(),
      ],
    );
  }
}
