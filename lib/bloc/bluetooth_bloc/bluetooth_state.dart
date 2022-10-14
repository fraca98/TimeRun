part of 'bluetooth_bloc.dart';

abstract class BluetoothState extends Equatable {
  const BluetoothState();
  
  @override
  List<Object> get props => [];
}

class BluetoothStateConnect extends BluetoothState {}

class BluetoothStateConnected extends BluetoothState {}
