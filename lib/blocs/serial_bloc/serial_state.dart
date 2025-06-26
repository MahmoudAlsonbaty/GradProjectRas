part of 'serial_bloc.dart';

@immutable
sealed class SerialState {
  final String logs;
  final Baudrate baud;
  final String port;
  const SerialState(this.logs, this.baud, this.port);
}

final class SerialInitial extends SerialState {
  SerialInitial(Baudrate rate, String port) : super('', rate, port);
}

final class SerialDataUpdate extends SerialState {
  SerialDataUpdate(String logs, Baudrate baud, String port)
      : super(logs, baud, port);
}
