import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/bluetooth_bloc/bluetooth_bloc.dart';
import 'package:timerun/screens/datacollectionPage.dart';

class BluetoothPage extends StatelessWidget {
  final int id;
  final List<String> sessionDevices;
  final int numSession;
  BuildContext detailcontext;

  BluetoothPage(
      {required this.numSession,
      required this.sessionDevices,
      required this.id,
      required this.detailcontext,
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
                    builder: (_) => DataCollectionPage(
                          polar: context.read<BluetoothBloc>().polar,
                          id: id,
                          numSession: numSession,
                          sessionDevices: sessionDevices,
                          detailcontext: detailcontext,
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
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
                  body: BlocListener<BluetoothBloc, BluetoothState>(
                    listener: ((context, state) {
                      String? message;
                      if (state is BluetoothStateConnect &&
                          state.sett != null) {
                        switch (state.sett) {
                          case 0:
                            message = "Activate the GPS";
                            break;
                          case 1:
                            message = "Activate the Bluetooth";
                            break;
                          case 2:
                            message = "Activate the GPS and the Bluetooth";
                            break;
                          default:
                        }
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          dismissDirection: DismissDirection.none,
                          content: Row(
                            children: [
                              state.sett! == 0 || state.sett! == 2
                                  ? Icon(
                                      MdiIcons.crosshairsGps,
                                      color: Colors.white,
                                    )
                                  : SizedBox(),
                              state.sett! == 1 || state.sett! == 2
                                  ? Icon(
                                      MdiIcons.bluetooth,
                                      color: Colors.white,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 15,
                              ),
                              message != null ? Text(message) : SizedBox(),
                            ],
                          ),
                          duration: Duration(days: 365),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      }
                    }),
                    child: Center(
                      child: Container(
                          height: 300,
                          child: LottieBuilder.asset(
                            'assets/bluetooth-devices.json',
                            frameRate: FrameRate.max,
                          )),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }
}
