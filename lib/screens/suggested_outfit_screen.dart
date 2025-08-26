import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/outfit_suggestion.dart';
import '../providers/vip_provider.dart';
import '../providers/wardrobe_provider.dart';
import '../services/suggestion_service.dart';
import '../utils/constants.dart';

/// Displays a single outfit suggestion for VIP users.  If the user is
/// not VIP or there are not enough items to form an outfit, an
/// appropriate message is shown.  This screen can be extended to
/// display multiple suggestions and allow the user to browse through
/// them.
class SuggestedOutfitScreen extends ConsumerWidget {
  const SuggestedOutfitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVip = ref.watch(isVipProvider);
    final items = ref.watch(wardrobeProvider);
    final OutfitSuggestion? suggestion =
        SuggestionService.generateSuggestion(items);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggested Outfit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isVip
            ? (suggestion == null
                ? Center(
                    child: Text(
                      'Not enough items to suggest an outfit. Please add more clothes.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  )
                : _OutfitCard(suggestion: suggestion))
            : Center(
                child: Text(
                  'Upgrade to VIP to get outfit suggestions.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({required this.suggestion});
  final OutfitSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your outfit',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12.0),
            _ItemRow(title: 'Top', item: suggestion.top),
            const SizedBox(height: 8.0),
            _ItemRow(title: 'Bottom', item: suggestion.bottom),
            if (suggestion.shoes != null) ...[
              const SizedBox(height: 8.0),
              _ItemRow(title: 'Shoes', item: suggestion.shoes!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.title, required this.item});
  final String title;
  final ClothingItem item;

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imagePath.isNotEmpty;
    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(item.name),
            Text(
              '${item.type} • ${item.color}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
