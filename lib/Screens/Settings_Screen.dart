import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:gradproject_management_system/widgets/backgroundFade.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _uartSendController = TextEditingController();
  String _uartReceived = '';
  bool _isSending = false;
  String _status = 'Idle';
  Serial? _serial;
  String _selectedPort = 'COM3';
  final List<String> _availablePorts = [
    'COM1',
    'COM2',
    'COM3',
    'COM4',
    'COM5',
    'COM6',
    'COM7',
    'COM8',
    'COM9',
    'COM10'
  ];

  @override
  void initState() {
    super.initState();
    _initSerial();
  }

  Future<void> _initSerial() async {
    try {
      _serial = Serial(_selectedPort, Baudrate.b115200);
      setState(() {
        _status = 'Serial Connected';
      });
    } catch (e) {
      setState(() {
        _status = 'Serial Error: $e';
      });
    }
  }

  Future<void> _sendSerial() async {
    setState(() {
      _isSending = true;
      _status = 'Sending...';
    });
    try {
      _serial?.writeString(_uartSendController.text + '\n');
      setState(() {
        _status = 'Sent! Waiting for response...';
      });
      final response = _serial?.read(128, 2000);
      setState(() {
        _uartReceived = response?.toString() ?? '';
        _status = 'Received!';
      });
    } catch (e) {
      setState(() {
        _status = 'Serial Error: $e';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _scanScript() async {
    setState(() {
      _status = 'Scanning...';
    });
    try {
      // Run the dummy Python script and capture its output
      final result = await Process.run('python3', ['assets/dummy_scan.py']);
      String output = result.stdout.toString().trim();
      if (output.isEmpty) output = 'No output from script.';
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Scan Result'),
          content: Text(output),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        _status = 'Scan complete!';
      });
    } catch (e) {
      setState(() {
        _status = 'Scan Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _uartSendController.dispose();
    _serial?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 270),
                child: myDrawer(selectedIndex: 4),
              ),
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    backgroundFaded(),
                    Center(
                      child: Container(
                        width: 800,
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: GoogleFonts.montserrat(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: hexToColor('2C5F9B'),
                              ),
                            ),
                            SizedBox(height: 32),
                            Text(
                              'Serial Communication',
                              style: GoogleFonts.openSans(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: hexToColor('212529'),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text('Port:',
                                    style: GoogleFonts.openSans(fontSize: 20)),
                                SizedBox(width: 16),
                                DropdownButton<String>(
                                  value: _selectedPort,
                                  items: _availablePorts.map((port) {
                                    return DropdownMenuItem<String>(
                                      value: port,
                                      child: Text(port),
                                    );
                                  }).toList(),
                                  onChanged: (value) async {
                                    if (value != null &&
                                        value != _selectedPort) {
                                      setState(() {
                                        _selectedPort = value;
                                        _status = 'Idle';
                                        _uartReceived = '';
                                      });
                                      _serial?.dispose();
                                      await _initSerial();
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: _uartSendController,
                              decoration: InputDecoration(
                                labelText: 'Send Data',
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.openSans(fontSize: 20),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _isSending ? null : _sendSerial,
                                  icon: Icon(Icons.send),
                                  label: Text('Send'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hexToColor('2C5F9B'),
                                    foregroundColor: Colors.white,
                                    textStyle:
                                        GoogleFonts.openSans(fontSize: 20),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24),
                                ElevatedButton.icon(
                                  onPressed: _scanScript,
                                  icon: Icon(Icons.qr_code_scanner),
                                  label: Text('Scan'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hexToColor('2C5F9B'),
                                    foregroundColor: Colors.white,
                                    textStyle:
                                        GoogleFonts.openSans(fontSize: 20),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24),
                                Text(
                                  _status,
                                  style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    color: _status.contains('Error')
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32),
                            Text(
                              'Received Data:',
                              style: GoogleFonts.openSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: hexToColor('212529'),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: hexToColor('2C5F9B'), width: 1),
                              ),
                              child: Text(
                                _uartReceived.isEmpty
                                    ? 'No data received yet.'
                                    : _uartReceived,
                                style: GoogleFonts.robotoMono(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
