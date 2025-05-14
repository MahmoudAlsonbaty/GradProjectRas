import 'package:gradproject_management_system/Const/Medication.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class inventoryItem {
  final int pharmacyID;
  final String id;
  final Medication medication;
  final int quantity;
  final int shelfNo;

  inventoryItem({
    required this.id,
    required this.pharmacyID,
    required this.medication,
    required this.quantity,
    required this.shelfNo,
  });

  // Create a Medication object from a map
  factory inventoryItem.fromMap(Map<String, dynamic> map, Medication med) {
    return inventoryItem(
      id: map['id'],
      pharmacyID: map['pharmacy_id'],
      medication: med,
      quantity: map['quantity'],
      shelfNo: map['shelf'],
    );
  }

  inventoryItem copyWith({
    int? pharmacyID,
    String? id,
    Medication? medication,
    int? quantity,
    int? shelfNo,
  }) {
    return inventoryItem(
      id: id ?? this.id,
      pharmacyID: pharmacyID ?? this.pharmacyID,
      medication: medication ?? this.medication,
      quantity: quantity ?? this.quantity,
      shelfNo: shelfNo ?? this.shelfNo,
    );
  }

  String toString() {
    return 'InventoryItem INFO: ID: $id, Name:${medication.name} ,Pharmacy ID: $pharmacyID, Medication ID: ${medication.id}, Quantity: $quantity, Shelf No: $shelfNo}';
  }
}
