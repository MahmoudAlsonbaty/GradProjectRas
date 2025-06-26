import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'dart:developer' as developer;

part 'serial_event.dart';
part 'serial_state.dart';

class SerialBloc extends Bloc<SerialEvent, SerialState> {
  Serial? _serial;
  String selectedPort = '/dev/ttyACM0';
  Baudrate selectedBaudRate = Baudrate.b9600;
  List<String> availablePorts = [
    '/dev/ttyACM0',
    '/dev/ttyACM1',
    '/dev/ttyACM2',
    '/dev/ttyACM3',
    '/dev/ttyACM4',
    '/dev/ttyACM5',
    '/dev/ttyACM6',
    '/dev/ttyACM7',
    '/dev/ttyACM8',
    '/dev/ttyACM9',
    '/dev/ttyACM10'
  ];
  List<Baudrate> availableBaudRates = [
    Baudrate.b9600,
    Baudrate.b19200,
    Baudrate.b38400,
    Baudrate.b57600,
    Baudrate.b115200,
    Baudrate.b1152000
  ];
  String logs = '';

  SerialBloc() : super(SerialInitial(Baudrate.b9600, '/dev/ttyACM0')) {
    developer.log('SerialBloc initialized', name: 'SerialBloc');
    _connectAndHandshake(selectedBaudRate, selectedPort);

    //
    // Handle New Connection
    //
    on<ConnectSerialDevice>((event, emit) async {
      selectedBaudRate = event.baudRate;
      selectedPort = event.port;
      _connectAndHandshake(selectedBaudRate, selectedPort);
      emit(SerialDataUpdate(logs, selectedBaudRate, selectedPort));
    });
    //
    // Sending Serial Data
    //
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
    //
    // Reading Serial Data
    //
    on<ReadSerialMessage>((event, emit) async {
      developer.log('ReadSerialMessage event', name: 'SerialBloc');
      try {
        final response = _serial?.read(event.length, event.timeoutMs);
        developer.log('Read from serial: ${response}', name: 'SerialBloc');
        logs = logs + response!.toString();
        emit(SerialDataUpdate(logs, selectedBaudRate, selectedPort));
      } catch (e, stack) {
        // developer.log('Error reading from serial: ${e.toString()}',
        //     name: 'SerialBloc', error: e, stackTrace: stack);

        developer.log('Error reading from serial: ', name: 'SerialBloc');
      }
    });
    //
    // Clearing Logs
    //
    on<ClearLogs>((event, emit) {
      developer.log('clearLogs event received', name: 'SerialBloc');
      logs = ''; // Clear the logs
      // Clear logs logic here, if applicable
      // For example, you might want to reset a logs variable or state
      // emit(SerialLogsCleared());
      emit(SerialDataUpdate(logs, selectedBaudRate, selectedPort));
    });

    //
    // Update Port
    //
    on<ChangeSerialPort>((event, emit) {
      developer.log('ChangeSerialPort event received', name: 'SerialBloc');
      selectedPort = event.port;
      emit(SerialDataUpdate(logs, selectedBaudRate, selectedPort));
    });

    //
    // Update BaudRate
    //
    on<ChangeSerialBaudrate>((event, emit) {
      developer.log('ChangeSerialBaudrate event received', name: 'SerialBloc');
      selectedBaudRate = event.baudRate;
      emit(SerialDataUpdate(logs, selectedBaudRate, selectedPort));
    });
    //
    // Generic Event
    //
    on<SerialEvent>((event, emit) {
      developer.log('SerialBloc received event: \\${event.runtimeType}',
          name: 'SerialBloc');
      // TODO: implement event handler
    });
  }

  Future<void> _connectAndHandshake(Baudrate baudRate, String port) async {
    try {
      developer.log(
          'Attempting to connect to serial port with $port at $baudRate',
          name: 'SerialBloc');
      // You may want to make the port and baudrate configurable
      _serial = Serial(port, baudRate);
      developer.log('Serial port connected', name: 'SerialBloc');
      _serial?.writeString('HANDSHAKE\n');
      developer.log('Sent HANDSHAKE message', name: 'SerialBloc');
      // Read response after handshake
      final response = _serial?.read(128, 2000); // 128 bytes, 2s timeout
      developer.log('Received from serial: \\${response}', name: 'SerialBloc');
      logs = logs + response!.toString();
      // If handshake is successful, send CALIBRATE
      if (response.toString().toUpperCase().contains('HANDSHAKE')) {
        developer.log('Handshake successful, sending CALIBRATE',
            name: 'SerialBloc');
        _serial?.writeString('CALIBRATE\n');
        developer.log('Sent CALIBRATE message', name: 'SerialBloc');
        // Wait for response after CALIBRATE
        final calibResponse = _serial?.read(128, 2000); // 128 bytes, 2s timeout
        logs = logs + calibResponse!.toString();
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
