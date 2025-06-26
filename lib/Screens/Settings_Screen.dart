import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glossy/glossy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/blocs/serial_bloc/serial_bloc.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:gradproject_management_system/widgets/backgroundFade.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _portSearchController =
      TextEditingController(); // Added for custom port entry
  final TextEditingController _baudRateSearchController =
      TextEditingController(); // Added for custom port entry
  final TextEditingController _uartSendController =
      TextEditingController(); // Added for custom port entry
  String _ConnectionStatus = 'Not Connected';

  Timer? _readSerialTimer;

  @override
  void initState() {
    super.initState();
    _readSerialTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        context.read<SerialBloc>().add(ReadSerialMessage());
      }
    });
  }

  @override
  void dispose() {
    _readSerialTimer?.cancel();
    _portSearchController.dispose(); // Dispose the controller
    _baudRateSearchController.dispose(); // Dispose the controller
    _uartSendController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            // Drawer
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 270),
              child: myDrawer(selectedIndex: 4),
            ),
            // Body
            BlocConsumer<SerialBloc, SerialState>(
              listener: (context, state) {
                context.read<SerialBloc>().logs;
              },
              builder: (context, state) {
                return Expanded(
                  flex: 5,
                  child: Stack(children: [
                    backgroundFaded(),
                    SettingsScreenBody(
                      context,
                      state,
                    )
                  ]),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

Widget SettingsScreenBody(BuildContext context, SerialState state) {
  final _settingsState =
      context.findAncestorStateOfType<_SettingsScreenState>();
  return Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SETTINGS",
          style: GoogleFonts.montserrat(
            fontSize: 72,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 10,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // Serial Port and Baud Rate Selection
        GlossyContainer(
          height: 150,
          width: MediaQuery.of(context).size.width * 0.83,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Serial Port Selection
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Serial Port:',
                      style: GoogleFonts.montserrat(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton2<String>(
                          isExpanded: true,
                          value: state.port,
                          underline: SizedBox.shrink(),
                          items: [
                            for (var port
                                in context.read<SerialBloc>().availablePorts)
                              DropdownMenuItem(
                                value: port,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(port,
                                      style: GoogleFonts.roboto(fontSize: 18)),
                                ),
                              )
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (!context
                                  .read<SerialBloc>()
                                  .availablePorts
                                  .contains(value)) {
                                context
                                    .read<SerialBloc>()
                                    .availablePorts
                                    .add(value!);
                              }
                              context
                                  .read<SerialBloc>()
                                  .add(ChangeSerialPort(value!));
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withAlpha(35),
                            ),
                            elevation: 0,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withAlpha(35),
                            ),
                            elevation: 0,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            iconSize: 32,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController:
                                _settingsState!._portSearchController,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _settingsState._portSearchController,
                                      decoration: InputDecoration(
                                        hintText: 'Type or select port',
                                        border: OutlineInputBorder(),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          if (context
                                              .read<SerialBloc>()
                                              .availablePorts
                                              .contains(value)) {
                                            context
                                                .read<SerialBloc>()
                                                .availablePorts
                                                .add(value);
                                          }
                                          context
                                              .read<SerialBloc>()
                                              .add(ChangeSerialPort(value));
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () {
                                      final value = _settingsState
                                          ._portSearchController.text;
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          if (!context
                                              .read<SerialBloc>()
                                              .availablePorts
                                              .contains(value)) {
                                            context
                                                .read<SerialBloc>()
                                                .availablePorts
                                                .add(value!);
                                          }
                                          context
                                              .read<SerialBloc>()
                                              .add(ChangeSerialPort(value!));
                                        });
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            searchInnerWidgetHeight:
                                60.0, // Added required height
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Serial BaudRate Selection
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Baud Rate:',
                      style: GoogleFonts.montserrat(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton2<String>(
                          isExpanded: true,
                          value: context
                              .read<SerialBloc>()
                              .selectedBaudRate
                              .toString(),
                          underline: SizedBox.shrink(),
                          items: [
                            for (var baudRate in context
                                .read<SerialBloc>()
                                .availableBaudRates)
                              DropdownMenuItem(
                                value: baudRate.toString(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(baudRate.toString(),
                                      style: GoogleFonts.roboto(fontSize: 18)),
                                ),
                              )
                          ],
                          onChanged: (value) {
                            switch (value) {
                              case "Baudrate.b9600":
                                context
                                    .read<SerialBloc>()
                                    .add(ChangeSerialBaudrate(Baudrate.b9600));
                                break;
                              case "Baudrate.b19200":
                                context
                                    .read<SerialBloc>()
                                    .add(ChangeSerialBaudrate(Baudrate.b19200));
                                break;
                              case "Baudrate.b38400":
                                context
                                    .read<SerialBloc>()
                                    .add(ChangeSerialBaudrate(Baudrate.b38400));
                                break;
                              case "Baudrate.b57600":
                                context
                                    .read<SerialBloc>()
                                    .add(ChangeSerialBaudrate(Baudrate.b57600));
                                break;
                              case "Baudrate.b115200":
                                context.read<SerialBloc>().add(
                                    ChangeSerialBaudrate(Baudrate.b115200));
                                break;
                              case "Baudrate.b1152000":
                                context.read<SerialBloc>().add(
                                    ChangeSerialBaudrate(Baudrate.b1152000));
                                break;
                            }
                            setState(() {});
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withAlpha(35),
                            ),
                            elevation: 0,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withAlpha(35),
                            ),
                            elevation: 0,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            iconSize: 32,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // Serial BaudRate Selection
              ),
              // Serial Connect Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor("2C5F9B"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  // Handle connect button press
                  context
                      .read<SerialBloc>()
                      .add(ConnectSerialDevice(state.baud, state.port));
                },
                child: Text('Connect',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Status: ${_settingsState!._ConnectionStatus}",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // Sending Data
        GlossyContainer(
          height: 150,
          width: MediaQuery.of(context).size.width * 0.83,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Send Data",
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _settingsState._uartSendController,
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.15),
                    hintText: 'Enter data to send',
                    hintStyle:
                        GoogleFonts.roboto(color: Colors.white70, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    prefixIcon: Icon(Icons.send, color: Colors.white70),
                  ),
                  cursorColor: Colors.blueAccent,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<SerialBloc>().add(SendSerialMessage(value));
                      _settingsState._uartSendController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // Monitor
        GlossyContainer(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.83,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Monitor",
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hexToColor("2C5F9B"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            context.read<SerialBloc>().add(ClearLogs());
                          },
                          child: Text('Clear Log',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    height: 300, // Set a fixed height for the monitor area
                    child: BlocBuilder<SerialBloc, SerialState>(
                      buildWhen: (previous, current) =>
                          previous.logs != current.logs,
                      builder: (context, state) {
                        return _LogScrollView(logText: state.logs);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

class _LogScrollView extends StatefulWidget {
  final String logText;
  const _LogScrollView({required this.logText});

  @override
  State<_LogScrollView> createState() => _LogScrollViewState();
}

class _LogScrollViewState extends State<_LogScrollView> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _LogScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.logText != oldWidget.logText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true,
      radius: const Radius.circular(12),
      thickness: 6,
      child: SingleChildScrollView(
        controller: _controller,
        padding: const EdgeInsets.all(12.0),
        child: Text(
          widget.logText,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
