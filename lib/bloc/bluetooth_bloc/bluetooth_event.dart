part of 'bluetooth_bloc.dart';

abstract class BluetoothEvent extends Equatable {
  const BluetoothEvent();

  @override
  List<Object> get props => [];
}

class BluetoothEventPressConnect extends BluetoothEvent{}

class BluetoothEventDisconnect extends BluetoothEvent{}