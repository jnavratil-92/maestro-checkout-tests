import 'dart:math';

import 'package:flutter/material.dart';

import '../ids/booking_ids.dart';

// Guards against a second "Continue"/"Pay"/"Confirm" tap landing while one
// is already in flight — the button stays enabled during the delay, and a
// fast double-tap would otherwise stack two loading dialogs and race two
// pop+navigate sequences on the same Navigator, leaving the app on an
// unpredictable screen.
bool _latencyInFlight = false;

/// Shows a full-screen loading overlay for a random 3-8s delay — standing
/// in for real backend latency on the main "next step" actions (Continue,
/// Pay/Confirm) — then runs [action] and pops the overlay. A no-op while
/// another call is already in flight.
Future<T?> withSimulatedLatency<T>(
  BuildContext context,
  Future<T> Function() action,
) async {
  if (_latencyInFlight) return null;
  _latencyInFlight = true;
  try {
    final delaySeconds = 3 + Random().nextInt(6); // 3-8 inclusive
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Semantics(
        identifier: LoadingIds.overlay,
        container: true,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
    await Future.delayed(Duration(seconds: delaySeconds));
    if (context.mounted) {
      // Pop the loading dialog itself before running [action] — otherwise
      // [action] pushing a new route lands on top of the dialog, and this
      // pop would dismiss that new route instead of the dialog.
      Navigator.of(context, rootNavigator: true).pop();
    }
    return await action();
  } finally {
    _latencyInFlight = false;
  }
}
