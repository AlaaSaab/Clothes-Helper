import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/constants.dart';

/// Screen displaying the full wardrobe.  Users can see all their
/// clothing items and perform simple actions such as toggling washing
/// state, toggling availability and deleting items.  Editing details
/// will be implemented in a future phase.
class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wardrobeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'Your wardrobe is empty.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final item = items[index];
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
                    // Confirm deletion
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
                        // In a future phase this will navigate to an edit screen.
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
