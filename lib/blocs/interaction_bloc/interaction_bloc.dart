import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:gradproject_management_system/Const/InteractionItem.dart';
import 'package:gradproject_management_system/Const/Medication.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'interaction_event.dart';
part 'interaction_state.dart';

class InteractionBloc extends Bloc<InteractionEvent, InteractionState> {
  InteractionBloc() : super(InteractionInitial()) {
    on<FetchInteractionList>((event, emit) async {
      developer.log('Fetching Interaction List', name: 'InteractionBloc');
      final supabase = Supabase.instance.client;
      final data = await supabase.from('interactions').select();
      // TODO: Map data to inventoryItem list
      List<drugInteraction> items = [];
      for (var row in data) {
        developer.log('fetched : $row', name: 'InteractionBloc');
        //Get Medication 1 info
        final med1Data = await supabase
            .from('medications')
            .select()
            .eq("id", row['Drug1_id'])
            .limit(1)
            .single(); //I think there's a better way to do this
        final med1 = Medication.fromMap(med1Data);
        //Get Medication 2 info
        final med2Data = await supabase
            .from('medications')
            .select()
            .eq("id", row['Drug2_id'])
            .limit(1)
            .single(); //I think there's a better way to do this
        final med2 = Medication.fromMap(med2Data);
        items.add(drugInteraction.fromMap(row, med1, med2));
      }
      emit(InteractionLoaded(interactionItems: items));
    });
  }
}
