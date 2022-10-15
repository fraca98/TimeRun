import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:timerun/bloc/bluetooth_bloc/bluetooth_bloc.dart';
import 'package:timerun/screens/datacollectionPage.dart';

class BluetoothPage extends StatelessWidget {
  final int id;
  final List<String> sessionDevices;
  final int numSession;

  BluetoothPage(
      {required this.numSession,
      required this.sessionDevices,
      required this.id,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BluetoothBloc(),
      child: BlocListener<BluetoothBloc, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothStateConnected) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DataCollectionPage(
                          id: id,
                          numSession: numSession,
                          sessionDevices: sessionDevices,
                        )));
          }
        },
        child: BlocBuilder<BluetoothBloc, BluetoothState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                if (state is BluetoothStateConnect) {
                  context.read<BluetoothBloc>().add(
                      BluetoothEventDisconnect()); //disconnect the Polar Device when i go back
                  return true;
                } else {
                  return false;
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Connect the Polar device',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading:
                      state is BluetoothStateConnect ? true : false,
                ),
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          height: 300,
                          child: LottieBuilder.asset(
                              'assets/bluetooth-devices.json')),
                      SizedBox(
                        height: 50,
                      ),
                      BlocBuilder<BluetoothBloc, BluetoothState>(
                        builder: (context, state) {
                          if (state is BluetoothStateConnect) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                              onPressed: () {
                                context
                                    .read<BluetoothBloc>()
                                    .add(BluetoothEventDisconnect()); //disconnect if i press button to be sure device is not connected
                                context
                                    .read<BluetoothBloc>()
                                    .add(BluetoothEventPressConnect());
                              },
                              child: Text(
                                'Connect Polar',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 20),
                              ),
                            );
                          }

                          if (state is BluetoothStateConnected) {
                            return CircularProgressIndicator();
                          } else {
                            return Text('Error BluetoothBloc');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
