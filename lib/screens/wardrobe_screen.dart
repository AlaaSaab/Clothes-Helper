import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/constants.dart';
import 'edit_item_screen.dart';
import '../providers/vip_provider.dart';
import '../widgets/banner_ad_widget.dart';

/// Screen displaying the full wardrobe.  Users can see all their
/// clothing items and perform simple actions such as toggling washing
/// state, toggling availability and deleting items.  Editing details
/// will be implemented in a future phase.
enum FilterOption { all, available, inWash, unavailable }

/// Riverpod state provider for the currently selected filter.  Defaults
/// to showing all items.
final filterProvider = StateProvider<FilterOption>((ref) => FilterOption.all);

class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wardrobeProvider);
    final isVip = ref.watch(isVipProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _FilterBar(),
            const SizedBox(height: 12.0),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'Your wardrobe is empty.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : _WardrobeList(items: items),
            ),
            if (!isVip) const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

/// A dropdown allowing the user to filter the wardrobe by availability
/// status.  When the selection changes it updates the [filterProvider].
class _FilterBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    return Row(
      children: [
        const Text('Filter:'),
        const SizedBox(width: 8.0),
        DropdownButton<FilterOption>(
          value: filter,
          items: const [
            DropdownMenuItem(value: FilterOption.all, child: Text('All')),
            DropdownMenuItem(value: FilterOption.available, child: Text('Available')),
            DropdownMenuItem(value: FilterOption.inWash, child: Text('In wash')),
            DropdownMenuItem(value: FilterOption.unavailable, child: Text('Unavailable')),
          ],
          onChanged: (FilterOption? newFilter) {
            if (newFilter != null) {
              ref.read(filterProvider.notifier).state = newFilter;
            }
          },
        ),
      ],
    );
  }
}

/// List widget that applies filtering to the given items based on
/// [filterProvider] and displays each item with actions.
class _WardrobeList extends ConsumerWidget {
  const _WardrobeList({required this.items});
  final List<ClothingItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    List<ClothingItem> filtered;
    switch (filter) {
      case FilterOption.available:
        filtered = items.where((i) => !i.inWash && i.isAvailable).toList();
        break;
      case FilterOption.inWash:
        filtered = items.where((i) => i.inWash).toList();
        break;
      case FilterOption.unavailable:
        filtered = items.where((i) => !i.isAvailable && !i.inWash).toList();
        break;
      case FilterOption.all:
      default:
        filtered = items;
    }
    if (filtered.isEmpty) {
      return Center(
        child: Text('No items match this filter.'),
      );
    }
    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8.0),
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Dismissible(
          key: ValueKey(item.id),
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete item'),
                content: const Text('Are you sure you want to delete this item?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) async {
            await ref.read(wardrobeProvider.notifier).deleteItem(item);
          },
          child: Card(
            elevation: 1,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(item.name.isNotEmpty ? item.name[0].toUpperCase() : '?'),
              ),
              title: Text(item.name),
              subtitle: Text('${item.type} • ${item.color}'),
              trailing: Wrap(
                spacing: 12.0,
                children: [
                  IconButton(
                    icon: Icon(
                      item.inWash ? Icons.local_laundry_service : Icons.local_laundry_service_outlined,
                      color: item.inWash ? Colors.blueGrey : null,
                    ),
                    tooltip: 'Toggle washing state',
                    onPressed: () async {
                      await ref.read(wardrobeProvider.notifier).toggleWashing(item);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      item.isAvailable ? Icons.check_circle_outline : Icons.block,
                      color: item.isAvailable ? Colors.green : Colors.red,
                    ),
                    tooltip: 'Toggle availability',
                    onPressed: () async {
                      await ref.read(wardrobeProvider.notifier).toggleAvailability(item);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditItemScreen(item: item),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
