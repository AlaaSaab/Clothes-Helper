import 'package:flutter/material.dart';

import 'vip_screen.dart';

/// A placeholder settings screen.  In later phases this page will include
/// options for theme selection, notification preferences and links to
/// legal documents.  For now it provides a simple entry point to the
/// VIP upgrade page.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Upgrade to VIP'),
            subtitle: const Text('Unlock outfit suggestions and remove ads'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VipScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              // In later phases this will open the privacy policy.
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Privacy Policy'),
                  content: const Text(
                      'A privacy policy will be added here in a future update.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
