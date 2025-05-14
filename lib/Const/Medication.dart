class Medication {
  final String id;
  final String name;
  final String active_ingredient;
  final String strength;
  final String form; // Could be changed to an enum if needed
  final int price;
  final String description;
  final String imageUrl;

  Medication({
    required this.id,
    required this.name,
    required this.active_ingredient,
    required this.strength,
    required this.price,
    required this.description,
    required this.form,
    required this.imageUrl,
  });

  // Create a Medication object from a map
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      active_ingredient: map['active_ingredient'],
      strength: map['strength'] ?? '0',
      form: map['form'],
      price: map['price'],
      description: map['description'] ?? 'No description available',
      imageUrl: map['image_url'], //We could use a default image URL if needed
    );
  }

  Medication copyWith({
    String? id,
    String? name,
    String? active_ingredient,
    String? strength,
    String? form,
    int? price,
    String? description,
    String? imageUrl,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      active_ingredient: active_ingredient ?? this.active_ingredient,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  String toString() {
    return 'Medication INFO: ID: $id, Name: $name, Active Ingredient: $active_ingredient, Strength: $strength, Form: $form, Price: $price, Description: $description, ImageURL: $imageUrl}';
  }
}
