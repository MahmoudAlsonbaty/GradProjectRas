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
  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      Text(
        "System Status",
        style: GoogleFonts.roboto(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 60,
      ),
      //! PRINT THE CHECKING STATUS MESSAGE
      () {
        if ((state.runtimeType == StatusLoading) ||
            (state.runtimeType == StatusUpdated &&
                    ((state as StatusUpdated).robotStatus ==
                        robotConnectionStatus.checking) ||
                (state as StatusUpdated).networkStatus ==
                    networkConnectionStatus.checking)) {
          return Text(
            "Checking Systems...",
            style: GoogleFonts.roboto(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          );
          //! SYSTEMS ARE CONNECTED
        } else if ((state.runtimeType == StatusUpdated &&
            ((state).robotStatus == robotConnectionStatus.connected) &&
            (state).networkStatus == networkConnectionStatus.connected)) {
          return Text(
            "Done Checking System!",
            style: GoogleFonts.roboto(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );

          //! ERROR IN THE STATUS
        } else {
          return Text(
            "Something Went Wrong!",
            style: GoogleFonts.roboto(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        }
      }(),
      SizedBox(
        height: 20,
      ),
      //statusScreenBodyContent(state),
      //! SHOW THE ANIMATION FOR STATUS
      () {
        //! LOADING STATUS
        if ((state.runtimeType == StatusLoading) ||
            (state.runtimeType == StatusUpdated &&
                    ((state as StatusUpdated).robotStatus ==
                        robotConnectionStatus.checking) ||
                (state as StatusUpdated).networkStatus ==
                    networkConnectionStatus.checking)) {
          return LoadingAnimationWidget.beat(
            color: Colors.white,
            size: 60,
          );
          //! SYSTEMS ARE CONNECTED
        } else if ((state.runtimeType == StatusUpdated &&
            ((state).robotStatus == robotConnectionStatus.connected) &&
            (state).networkStatus == networkConnectionStatus.connected)) {
          return Icon(Icons.check_circle_outline,
              color: Colors.green, size: 60);

          //! ERROR IN THE STATUS
        } else {
          return Icon(Icons.error, color: Colors.red, size: 60);
        }
      }()

      //! THE AVR STATUS
      ,
      SizedBox(
        height: 90,
      ),
      () {
        if (state.runtimeType == StatusUpdated) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Robot Status: ",
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              () {
                if ((state as StatusUpdated).robotStatus ==
                    robotConnectionStatus.connected) {
                  return Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 30);
                } else {
                  return Icon(Icons.error, color: Colors.red, size: 30);
                }
              }()
            ],
          );
        } else {
          return Row();
        }
      }(),
      SizedBox(
        height: 5,
      ),
      () {
        if (state.runtimeType == StatusUpdated) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Server Status: ",
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              () {
                if ((state as StatusUpdated).networkStatus ==
                    networkConnectionStatus.connected) {
                  return Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 30);
                } else {
                  return Icon(Icons.error, color: Colors.red, size: 30);
                }
              }()
            ],
          );
        } else {
          return Row();
        }
      }()
    ],
  );
//   if (state.runtimeType == StatusLoading) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         StatusTitleWidget(),
//         SizedBox(
//           height: 60,
//         ),
//         Text(
//           "Checking Systems...",
//           style: GoogleFonts.roboto(
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//             color: Colors.yellow,
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),

//       ],
//     );
//   } else if (state.runtimeType == StatusUpdated) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         StatusTitleWidget(),
//         SizedBox(
//           height: 60,
//         ),
//         BigStatusWidget(state as StatusUpdated),
//       ],
//     );
//   } else {
//     return Container(); // REMOVE THIS
//   }
// }

// Widget BigStatusWidget(StatusUpdated state) {
//   if (state.networkStatus == networkConnectionStatus.connected) {
//     return LoadingAnimationWidget.bouncingBall(color: Colors.white, size: 60);
//   } else {
//     return LoadingAnimationWidget.beat(
//       color: Colors.white,
//       size: 60,
//     );
//   }
// }
}
