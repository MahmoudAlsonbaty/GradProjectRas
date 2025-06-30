part of 'interaction_bloc.dart';

@immutable
sealed class InteractionState {}

final class InteractionInitial extends InteractionState {}

final class InteractionLoaded extends InteractionState {
  final List<drugInteraction> interactionItems;
  InteractionLoaded({required this.interactionItems});
}
