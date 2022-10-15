import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polar/polar.dart';
import 'package:timerun/model/device.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  bool connected = false;
  Polar polar = Polar();
  BluetoothBloc() : super(BluetoothStateConnect()) {
    polar.deviceConnectingStream.listen((event) {
      print('Connecting: ${event.name}');
    });
    polar.deviceConnectedStream.listen((event) {
      print('Connected: ${event.name}');
      emit(BluetoothStateConnected());
    });

    on<BluetoothEventPressConnect>(
      (event, emit) {
        polar.connectToDevice(polarIdentifier);
      },
    );

    on<BluetoothEventBack>(
      (event, emit) {
        polar.disconnectFromDevice(polarIdentifier);
      },
    );
  }
}
