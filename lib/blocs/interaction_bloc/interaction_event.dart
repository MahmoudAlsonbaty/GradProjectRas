part of 'interaction_bloc.dart';

@immutable
sealed class InteractionEvent {
  const InteractionEvent();
}

final class FetchInteractionList extends InteractionEvent {
  const FetchInteractionList();
}
