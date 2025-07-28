import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'utils/constants.dart';
import 'screens/home_screen.dart';

/// The root widget of the Clothes Helper application.  It wraps the
/// [MaterialApp] in a [ProviderScope] to make Riverpod providers
/// available throughout the widget tree.  It also configures light
/// and dark themes based on the definitions in [AppTheme].
class ClothesHelperApp extends StatelessWidget {
  const ClothesHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Clothes Helper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
