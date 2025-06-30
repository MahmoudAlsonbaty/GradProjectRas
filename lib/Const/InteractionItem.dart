import 'package:gradproject_management_system/Const/Medication.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class drugInteraction {
  final int id;
  final Medication medication1;
  final Medication medication2;
  final String note;

  drugInteraction({
    required this.id,
    required this.medication1,
    required this.medication2,
    required this.note,
  });

  // Create a Medication object from a map
  factory drugInteraction.fromMap(
      Map<String, dynamic> map, Medication med1, Medication med2) {
    return drugInteraction(
      id: map['id'],
      medication1: med1,
      medication2: med2,
      note: map['note'],
    );
  }

  drugInteraction copyWith({
    final int? id,
    final Medication? medication1,
    final Medication? medication2,
    final String? note,
  }) {
    return drugInteraction(
      id: id ?? this.id,
      medication1: medication1 ?? this.medication1,
      medication2: medication2 ?? this.medication2,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return "MED1 ${medication1.name}=${medication1.id} , MED2 ${medication2.name}=${medication2.id} ";
  }
}
