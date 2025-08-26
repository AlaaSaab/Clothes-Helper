import 'clothing_item.dart';

/// Represents a simple outfit comprised of a top, a bottom and
/// optionally shoes.  Additional accessories could be added in later
/// versions.
class OutfitSuggestion {
  final ClothingItem top;
  final ClothingItem bottom;
  final ClothingItem? shoes;

  OutfitSuggestion({required this.top, required this.bottom, this.shoes});
}
