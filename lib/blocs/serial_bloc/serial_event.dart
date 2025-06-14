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
  ReadSerialMessage({this.length = 128, this.timeoutMs = 2000});
}
