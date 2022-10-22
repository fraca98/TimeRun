import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:polar/polar.dart';

import '../../model/device.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  Polar polar = Polar();
  StreamSubscription? polarConnect;
  StreamSubscription? polarConnected;
  StreamSubscription? polarDisconnect;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription? settingsSubSub;

  Stream<List<bool>> settingsStream() async* {
    while (true) {
      bool gps = await Geolocator.isLocationServiceEnabled();
      bool blue = await FlutterBluePlus.instance.isOn;
      yield [gps, blue]; //first value GPS, second Bluetooth (true/false enabled)
      await Future.delayed(Duration(seconds: 1));
    }
  }

  BluetoothBloc() : super(BluetoothStateConnect()) {
    settingsSubSub = settingsStream().listen((value) {
      //print(value);
      if (value[0] == false && value[1] == false) {
        emit(BluetoothStateConnect(sett: 2));
      } else if (value[0] == false && value[1] == true) {
        emit(BluetoothStateConnect(sett: 0));
      } else if (value[0] == true && value[1] == false) {
        emit(BluetoothStateConnect(sett: 1));
      } else {
        if (state is BluetoothStateConnect &&
            (state as BluetoothStateConnect).sett == 0) {
          //if GPS re-established i need to launch again the connection
          add(BluetoothEventDisconnect());
          add(BluetoothEventConnect());
        }
        emit(BluetoothStateConnect());
      }
    });

    polarConnect = polar.deviceConnectingStream.listen((event) {
      print('Connecting: ${event.name}');
    });
    polarConnected = polar.deviceConnectedStream.listen((event) {
      print('Connected: ${event.name}');
      emit(BluetoothStateConnected());
    });

    polarDisconnect = polar.deviceDisconnectedStream.listen((event) {
      print('Disconnected: ${event.name}');
    });

    on<BluetoothEventConnect>(
      (event, emit) {
        polar.connectToDevice(polarIdentifier);
      },
    );

    on<BluetoothEventDisconnect>(
      (event, emit) {
        polar.disconnectFromDevice(polarIdentifier);
      },
    );
    add(BluetoothEventDisconnect()); //to be sure if app crashed or closed inappropiately to be no more connected
    add(BluetoothEventConnect()); //attemp to connect on start
  }

  @override
  Future<void> close() async {
    polarConnect?.cancel();
    polarConnected?.cancel();
    polarDisconnect?.cancel();
    settingsSubSub?.cancel();

    return super.close();
  }
}
