import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusLoading()) {
    on<RefreshStatusPageEvent>((event, emit) async {
      emit(StatusLoading());
      await Future.delayed(Duration(seconds: 3));
      // Emit the next state after the delay
      emit(StatusUpdated(
          robotConnectionStatus.checking, networkConnectionStatus.checking));

      await Future.delayed(Duration(seconds: 3));
      // Emit the next state after the delay
      emit(StatusUpdated(
          robotConnectionStatus.connected, networkConnectionStatus.connected));
    });
  }
}
