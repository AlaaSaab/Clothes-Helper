import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/constants.dart';
import 'add_item_screen.dart';
import 'wardrobe_screen.dart';
import 'settings_screen.dart';
import 'vip_screen.dart';

/// The home screen presents a simple overview of the user's wardrobe and
/// provides navigation to other parts of the app.  In later phases this
/// screen can display outfit suggestions, quick filters, and summary
/// statistics.  For now it serves as the entry point to the Add Item,
/// Wardrobe, Settings and VIP pages.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wardrobeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothes Helper'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick actions
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                _ActionButton(
                  icon: Icons.add,
                  label: 'Add Item',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddItemScreen()),
                  ),
                ),
                _ActionButton(
                  icon: Icons.inventory_2_outlined,
                  label: 'Wardrobe',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WardrobeScreen()),
                  ),
                ),
                _ActionButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                _ActionButton(
                  icon: Icons.star,
                  label: 'VIP',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VipScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Text(
              'Your Wardrobe',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'No items added yet.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(item.name.isNotEmpty ? item.name[0].toUpperCase() : '?'),
                          ),
                          title: Text(item.name),
                          subtitle: Text('${item.type} • ${item.color}'),
                          trailing: Icon(
                            item.inWash
                                ? Icons.local_laundry_service
                                : item.isAvailable
                                    ? Icons.check_circle_outline
                                    : Icons.block,
                            color: item.inWash
                                ? Colors.blueGrey
                                : item.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          onTap: () {
                            // Navigate to wardrobe page for details/editing in later phases.
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const WardrobeScreen()),
                            );
                          },
                        );
                      },
                    ),
            ),
            // Placeholder for banner ad
            Container(
              height: 50,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Text('Ad banner placeholder'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small reusable button used on the home screen for quick actions.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
