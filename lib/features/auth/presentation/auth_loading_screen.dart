import 'package:flutter/material.dart';

/// A temporary screen displayed while the initial Supabase session is loading.
///
/// The router sends users here so a protected task screen never flashes before
/// the app knows whether a session exists.
class AuthLoadingScreen extends StatelessWidget {
  /// Creates the session-loading screen.
  const AuthLoadingScreen({super.key});

  @override
  /// Builds a minimal loading indicator while routing is intentionally paused.
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
