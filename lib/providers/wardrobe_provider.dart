import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clothing_item.dart';
import '../services/storage_service.dart';

/// A Riverpod provider that exposes an instance of [WardrobeNotifier].  It
/// takes a [StorageService] as a dependency, allowing the notifier to
/// interact with Hive.  In a real application you might use a
/// dependency injection framework or override this provider in tests.
final wardrobeProvider = StateNotifierProvider<WardrobeNotifier, List<ClothingItem>>((ref) {
  final storageService = StorageService();
  final notifier = WardrobeNotifier(storageService);
  return notifier;
});

/// A [StateNotifier] that manages a list of [ClothingItem] objects.  It
/// exposes methods for loading from storage, adding new items, updating,
/// deleting and toggling states.  The state is simply a list of
/// clothing items which will trigger UI updates when changed.
class WardrobeNotifier extends StateNotifier<List<ClothingItem>> {
  WardrobeNotifier(this._storageService) : super(const []) {
    _init();
  }

  final StorageService _storageService;

  /// Initialise the notifier by opening the storage box and loading
  /// existing items.
  Future<void> _init() async {
    await _storageService.init();
    state = _storageService.getAllItems();
  }

  /// Add a new clothing item to the wardrobe and persist it.
  Future<void> addItem(ClothingItem item) async {
    state = [...state, item];
    await _storageService.addItem(item);
  }

  /// Update an existing clothing item.  The matching item is replaced
  /// in the list based on id.
  Future<void> updateItem(ClothingItem item) async {
    state = [for (final i in state) i.id == item.id ? item : i];
    await _storageService.updateItem(item);
  }

  /// Remove an item from the wardrobe.
  Future<void> deleteItem(ClothingItem item) async {
    state = state.where((i) => i.id != item.id).toList();
    await _storageService.deleteItem(item.id);
  }

  /// Toggle the washing state of an item.
  Future<void> toggleWashing(ClothingItem item) async {
    final updated = ClothingItem(
      id: item.id,
      name: item.name,
      type: item.type,
      color: item.color,
      imagePath: item.imagePath,
      inWash: !item.inWash,
      isAvailable: item.isAvailable,
    );
    await updateItem(updated);
  }

  /// Toggle the availability of an item.
  Future<void> toggleAvailability(ClothingItem item) async {
    final updated = ClothingItem(
      id: item.id,
      name: item.name,
      type: item.type,
      color: item.color,
      imagePath: item.imagePath,
      inWash: item.inWash,
      isAvailable: !item.isAvailable,
    );
    await updateItem(updated);
  }
}
