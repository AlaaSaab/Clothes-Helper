import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple provider tracking whether the user has VIP status.  In
/// Phase 3 this will be tied to an in‑app purchase or subscription
/// backend.  For now it can be toggled to simulate upgrading.
final isVipProvider = StateProvider<bool>((ref) => false);
