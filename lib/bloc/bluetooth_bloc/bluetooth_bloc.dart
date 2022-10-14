import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polar/polar.dart';
import 'package:timerun/model/device.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  bool connected = false;
  BluetoothBloc() : super(BluetoothStateConnect()) {
    Polar().deviceConnectingStream.listen((event) {
      print('Connecting: ${event.name}');
    });
    Polar().deviceConnectedStream.listen((event) {
      print('Connected: ${event.name}');
      emit(BluetoothStateConnected());
    });

    on<BluetoothEventPressConnect>(
      (event, emit) {
        Polar().connectToDevice(polarIdentifier);
      },
    );
  }
}
