part of 'status_bloc.dart';

sealed class StatusEvent {
  const StatusEvent();
}

final class RefreshStatusPageEvent extends StatusEvent {
  const RefreshStatusPageEvent();
}

final class getRobotConectionEvent extends StatusEvent {
  const getRobotConectionEvent();
}
