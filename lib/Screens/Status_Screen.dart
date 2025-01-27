import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/blocs/status_bloc/status_bloc.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.title});
  final String title;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(165, 212, 227, 1),
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            // Drawer
            Flexible(
              flex: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 270), // Logo Max Width
                child: myDrawer(
                  selectedIndex: 0,
                ),
              ),
            ),
            // Body
            BlocConsumer<StatusBloc, StatusState>(
              listener: (context, state) {
                print(state.toString());
              },
              builder: (context, state) {
                return Expanded(
                  flex: 5,
                  child: statusScreenBody(state),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

Widget statusScreenBody(StatusState state) {
  if (state.runtimeType == StatusLoading) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "System Status",
          style: GoogleFonts.roboto(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 60,
        ),
        LoadingAnimationWidget.beat(
          color: Colors.white,
          size: 60,
        )
      ],
    );
  } else if (state.runtimeType == StatusUpdated) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "System Status",
          style: GoogleFonts.roboto(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 60,
        ),
        BigStatusWidget(state as StatusUpdated),
      ],
    );
  } else {
    return Container(); // REMOVE THIS
  }
}

Widget BigStatusWidget(StatusUpdated state) {
  if (state.networkStatus == networkConnectionStatus.connected) {
    return LoadingAnimationWidget.bouncingBall(color: Colors.white, size: 60);
  } else {
    return LoadingAnimationWidget.beat(
      color: Colors.white,
      size: 60,
    );
  }
}
