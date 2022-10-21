part of 'bluetooth_bloc.dart';

abstract class BluetoothState extends Equatable {
  const BluetoothState();

  @override
  List<Object?> get props => [];
}

class BluetoothStateConnect extends BluetoothState {
  int? sett;
  BluetoothStateConnect({this.sett});
  /*
  0: GPS not active
  1: Bluetooth not active
  2: GPS+Bluetooth not active
  3: OK: both Active
  */

  @override
  List<Object?> get props => [sett];
}

class BluetoothStateConnected extends BluetoothState {}
