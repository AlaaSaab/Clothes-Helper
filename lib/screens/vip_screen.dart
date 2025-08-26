import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/constants.dart';
import '../providers/vip_provider.dart';
import 'suggested_outfit_screen.dart';

/// A simple page describing the benefits of upgrading to VIP.  In later
/// phases this page will integrate with in‑app purchase APIs to allow
/// users to subscribe or make a one‑time purchase.  It currently
/// outlines the advantages of VIP membership.
class VipScreen extends ConsumerWidget {
  const VipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVip = ref.watch(isVipProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP Membership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isVip ? 'Thank you for being a VIP' : 'Become a VIP',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            _benefitItem(
              icon: Icons.check_circle_outline,
              title: 'Remove Ads',
              description: 'Enjoy an ad‑free experience and focus on your wardrobe.',
            ),
            _benefitItem(
              icon: Icons.style,
              title: 'Outfit Suggestions',
              description: 'Get personalised outfit ideas based on colour matching and seasons.',
            ),
            _benefitItem(
              icon: Icons.cloud_sync,
              title: 'Cloud Sync (future)',
              description: 'Backup your wardrobe and access it across devices.',
            ),
            const Spacer(),
            if (isVip) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SuggestedOutfitScreen()),
                    );
                  },
                  child: const Text('View Suggested Outfit'),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Simulate upgrade by toggling the provider
                    ref.read(isVipProvider.notifier).state = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for upgrading!')),
                    );
                  },
                  child: const Text('Upgrade Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper to build a descriptive item for a VIP benefit.
  Widget _benefitItem({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
