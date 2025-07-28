/// Model class representing a single piece of clothing in the wardrobe.
///
/// This class uses simple fields and `toMap`/`fromMap` conversions to make
/// it easy to persist to Hive.  In a full implementation you might
/// generate a TypeAdapter for more efficient storage, but that requires
/// build runner which isn't available in this environment.
class ClothingItem {
  /// Unique identifier for the clothing item.
  final String id;

  /// Human‑readable name (e.g. "Blue T‑Shirt").
  final String name;

  /// Type of garment (e.g. "Shirt", "Pants", "Shoes").
  final String type;

  /// Colour description or hex string.
  final String color;

  /// Path to the image stored locally on the device.
  final String imagePath;

  /// Whether the item is currently in the wash.
  bool inWash;

  /// Whether the item is available to be worn (i.e. not lost/damaged).
  bool isAvailable;

  ClothingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.imagePath,
    this.inWash = false,
    this.isAvailable = true,
  });

  /// Convert a [ClothingItem] into a serialisable map.  This is useful
  /// for storing the item in Hive using a Box of type `Map`.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'color': color,
      'imagePath': imagePath,
      'inWash': inWash,
      'isAvailable': isAvailable,
    };
  }

  /// Create a [ClothingItem] from a map representation.  If keys are
  /// missing the constructor will throw; ensure your stored data is
  /// complete.
  factory ClothingItem.fromMap(Map<String, dynamic> map) {
    return ClothingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      color: map['color'] as String,
      imagePath: map['imagePath'] as String,
      inWash: map['inWash'] as bool? ?? false,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }
}
