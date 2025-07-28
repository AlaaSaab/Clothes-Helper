import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/clothing_item.dart';

/// A service class responsible for handling all interactions with the
/// local Hive database.  It encapsulates the logic for opening boxes,
/// reading/writing items and notifying listeners when data changes.
class StorageService {
  static const String _boxName = 'wardrobeBox';

  Box<Map>? _box;

  /// Initialise Hive and open the wardrobe box.  This method should be
  /// called before any other methods on this service are used.
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<Map>(_boxName);
  }

  /// Return all clothing items currently stored in the box.  The items
  /// are converted from map representations into [ClothingItem] objects.
  List<ClothingItem> getAllItems() {
    if (_box == null) return [];
    return _box!.values
        .map((Map entry) => ClothingItem.fromMap(Map<String, dynamic>.from(entry)))
        .toList();
  }

  /// Add a new [ClothingItem] to the box.  A unique id should be set
  /// on the item before calling this method.
  Future<void> addItem(ClothingItem item) async {
    await _box?.put(item.id, item.toMap());
  }

  /// Update an existing [ClothingItem] in the box.  This will overwrite
  /// the existing entry keyed by the item's id.
  Future<void> updateItem(ClothingItem item) async {
    await _box?.put(item.id, item.toMap());
  }

  /// Remove an item from the box by its id.
  Future<void> deleteItem(String id) async {
    await _box?.delete(id);
  }

  /// Toggle the washing state of an item.  This is a convenience method
  /// to demonstrate state changes; it reads the item, flips the flag
  /// and writes it back to the box.
  Future<void> toggleWashing(String id) async {
    final map = _box?.get(id);
    if (map == null) return;
    final item = ClothingItem.fromMap(Map<String, dynamic>.from(map));
    item.inWash = !item.inWash;
    await updateItem(item);
  }

  /// Toggle the availability state of an item.
  Future<void> toggleAvailability(String id) async {
    final map = _box?.get(id);
    if (map == null) return;
    final item = ClothingItem.fromMap(Map<String, dynamic>.from(map));
    item.isAvailable = !item.isAvailable;
    await updateItem(item);
  }
}
