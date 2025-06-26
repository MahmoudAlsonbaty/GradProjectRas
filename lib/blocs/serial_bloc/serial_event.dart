part of 'serial_bloc.dart';

@immutable
sealed class SerialEvent {}

@immutable
class SendSerialMessage extends SerialEvent {
  final String message;
  SendSerialMessage(this.message);
}

@immutable
class ReadSerialMessage extends SerialEvent {
  final int length;
  final int timeoutMs;
  ReadSerialMessage({this.length = 128, this.timeoutMs = 0});
}

class ClearLogs extends SerialEvent {}

class ConnectSerialDevice extends SerialEvent {
  final Baudrate baudRate;
  final String port;
  ConnectSerialDevice(this.baudRate, this.port);
}

class ChangeSerialPort extends SerialEvent {
  final String port;
  ChangeSerialPort(this.port);
}

class ChangeSerialBaudrate extends SerialEvent {
  final Baudrate baudRate;
  ChangeSerialBaudrate(this.baudRate);
}
