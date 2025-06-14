import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'dart:developer' as developer;

part 'serial_event.dart';
part 'serial_state.dart';

class SerialBloc extends Bloc<SerialEvent, SerialState> {
  Serial? _serial;

  SerialBloc() : super(SerialInitial()) {
    developer.log('SerialBloc initialized', name: 'SerialBloc');
    _connectAndHandshake();
    on<SendSerialMessage>((event, emit) async {
      developer.log('SendSerialMessage event: ${event.message}',
          name: 'SerialBloc');
      try {
        _serial?.writeString(event.message + '\n');
        developer.log('Sent message: ${event.message}', name: 'SerialBloc');
      } catch (e, stack) {
        developer.log('Error sending message: ${e.toString()}',
            name: 'SerialBloc', error: e, stackTrace: stack);
      }
    });
    on<ReadSerialMessage>((event, emit) async {
      developer.log('ReadSerialMessage event', name: 'SerialBloc');
      try {
        final response = _serial?.read(event.length, event.timeoutMs);
        developer.log('Read from serial: ${response}', name: 'SerialBloc');
      } catch (e, stack) {
        developer.log('Error reading from serial: ${e.toString()}',
            name: 'SerialBloc', error: e, stackTrace: stack);
      }
    });
    on<SerialEvent>((event, emit) {
      developer.log('SerialBloc received event: \\${event.runtimeType}',
          name: 'SerialBloc');
      // TODO: implement event handler
    });
  }

  Future<void> _connectAndHandshake() async {
    try {
      developer.log('Attempting to connect to serial port', name: 'SerialBloc');
      // You may want to make the port and baudrate configurable
      _serial = Serial('COM3', Baudrate.b115200);
      developer.log('Serial port connected', name: 'SerialBloc');
      _serial?.writeString('HANDSHAKE\n');
      developer.log('Sent HANDSHAKE message', name: 'SerialBloc');
      // Read response after handshake
      final response = _serial?.read(128, 2000); // 128 bytes, 2s timeout
      developer.log('Received from serial: \\${response}', name: 'SerialBloc');
      // If handshake is successful, send CALIBRATE
      if (response != null &&
          response.toString().toUpperCase().contains('HANDSHAKE')) {
        developer.log('Handshake successful, sending CALIBRATE',
            name: 'SerialBloc');
        _serial?.writeString('CALIBRATE\n');
        developer.log('Sent CALIBRATE message', name: 'SerialBloc');
        // Wait for response after CALIBRATE
        final calibResponse = _serial?.read(128, 2000); // 128 bytes, 2s timeout
        developer.log(
            'Received from serial after CALIBRATE: \\${calibResponse}',
            name: 'SerialBloc');
      } else {
        developer.log('Handshake failed or unexpected response',
            name: 'SerialBloc');
      }
    } catch (e, stack) {
      developer.log('Error connecting to serial port: \\${e.toString()}',
          name: 'SerialBloc', error: e, stackTrace: stack);
    }
  }
}
