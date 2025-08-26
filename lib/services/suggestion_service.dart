import '../models/clothing_item.dart';
import '../models/outfit_suggestion.dart';

/// A naive recommendation engine that generates outfit suggestions based on
/// predefined heuristics.  The current implementation simply selects
/// the first available top and bottom from the wardrobe and pairs them
/// together.  In future phases this can be extended to use colour
/// matching, seasonal rules, style preferences, etc.
class SuggestionService {
  /// Generate a single [OutfitSuggestion] from the given list of
  /// [ClothingItem]s.  Returns `null` if not enough items are
  /// available to form an outfit (i.e. no top or bottom).
  static OutfitSuggestion? generateSuggestion(List<ClothingItem> items) {
    // Filter only items that are not in wash and available.
    final available = items.where((i) => !i.inWash && i.isAvailable).toList();
    // Identify tops and bottoms.
    const topTypes = {
      'Shirt',
      'T‑Shirt',
      'Sweater',
      'Jacket',
      'Coat',
    };
    const bottomTypes = {
      'Pants',
      'Shorts',
      'Skirt',
    };
    ClothingItem? top;
    ClothingItem? bottom;
    ClothingItem? shoes;
    for (final item in available) {
      if (top == null && topTypes.contains(item.type)) {
        top = item;
      } else if (bottom == null && bottomTypes.contains(item.type)) {
        bottom = item;
      } else if (shoes == null && item.type == 'Shoes') {
        shoes = item;
      }
    }
    if (top == null || bottom == null) {
      return null;
    }
    return OutfitSuggestion(top: top, bottom: bottom, shoes: shoes);
  }
}
