part of 'status_bloc.dart';

@immutable
sealed class StatusState {
  const StatusState();
}

enum robotConnectionStatus { checking, connected, disconnected }

enum networkConnectionStatus { checking, connected, disconnected }

final class StatusLoading extends StatusState {}

final class StatusUpdated extends StatusState {
  final robotConnectionStatus robotStatus;
  final networkConnectionStatus networkStatus;

  @override
  String toString() {
    return "Robot Status: $robotStatus, Network Status: $networkStatus";
  }

  const StatusUpdated(this.robotStatus, this.networkStatus);
}
