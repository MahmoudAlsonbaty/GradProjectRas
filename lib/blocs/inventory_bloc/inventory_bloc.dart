import 'package:bloc/bloc.dart';
import 'package:gradproject_management_system/Const/InventoryItem.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:gradproject_management_system/Const/Medication.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

//Shelf : Medicine Name Present in Shelf

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryLoaded(inventoryItems: [])) {
    on<FetchInventoryFromCloudEvent>(_onFetchInventoryFromCloud);

    on<UpdateInventoryInCloudEvent>(_onUpdateInventoryInCloud);

    on<UpdateSingleInventoryItemEvent>(_onUpdateSingleInventoryItem);

    on<RefreshInventoryContentEvent>((event, emit) async {
      final items = await _getCachedInventory();
      emit(InventoryLoaded(inventoryItems: items));
    });

    on<InventorySearchEvent>((event, emit) async {
      final items = await _getCachedInventory();
      emit(InventorySearched(
          inventoryItems: items, searchTerm: event.searchTerm));
    });
  }

  Future<void> _onFetchInventoryFromCloud(
      FetchInventoryFromCloudEvent event, Emitter<InventoryState> emit) async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('inventory')
        .select()
        .eq("pharmacy_id", 1); //Replace with actual pharmacy ID
    // TODO: Map data to inventoryItem list
    List<inventoryItem> items = [];
    for (var row in data) {
      //We're
      final medData = await supabase
          .from('medications')
          .select()
          .eq("id", row['medication_id'])
          .limit(1)
          .single(); //I think there's a better way to do this
      final med = Medication.fromMap(medData);
      items.add(inventoryItem.fromMap(row, med));
    }
    await _cacheInventory(items);
    emit(InventoryLoaded(inventoryItems: items));
  }

  Future<void> _onUpdateInventoryInCloud(
      UpdateInventoryInCloudEvent event, Emitter<InventoryState> emit) async {
    final supabase = Supabase.instance.client;
    for (var item in event.inventoryItems) {
      await supabase.from('medications').update({
        'quantity': item.quantity,
        'shelf': item.shelfNo,
      }).eq('id', item.id);
    }
    await _cacheInventory(event.inventoryItems);
    emit(InventoryLoaded(inventoryItems: event.inventoryItems));
  }

  Future<void> _onUpdateSingleInventoryItem(
      UpdateSingleInventoryItemEvent event,
      Emitter<InventoryState> emit) async {
    final supabase = Supabase.instance.client;
    final item = event.updatedItem;
    //TODO: Update the item medication too (if it changed)
    await supabase.from('inventory').update({
      'quantity': item.quantity,
      'shelf': item.shelfNo,
    }).eq('id', item.id);
    // Update cache
    final currentItems = await _getCachedInventory();
    final updatedItems =
        currentItems.map((inv) => inv.id == item.id ? item : inv).toList();
    await _cacheInventory(updatedItems);
    emit(InventoryLoaded(inventoryItems: updatedItems));
  }

  Future<void> _cacheInventory(List<inventoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = items
        .map((e) => {
              'id': e.id,
              'pharmacy_id': e.pharmacyID,
              'quantity': e.quantity,
              'shelf': e.shelfNo,
              'medication': {
                'id': e.medication.id,
                'name': e.medication.name,
                'active_ingredient': e.medication.active_ingredient,
                'strength': e.medication.strength,
                'form': e.medication.form,
                'price': e.medication.price,
                'description': e.medication.description,
                'image_url': e.medication.imageUrl,
              }
            })
        .toList();
    prefs.setString('cached_inventory', jsonEncode(encoded));
  }

  Future<List<inventoryItem>> _getCachedInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_inventory');
    if (cached == null) return [];
    final List<dynamic> decoded = jsonDecode(cached);
    return decoded
        .map((e) =>
            inventoryItem.fromMap(e, Medication.fromMap(e['medication'])))
        .toList();
  }
}
