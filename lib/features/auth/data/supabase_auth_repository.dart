import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks_app/features/auth/domain/app_user.dart';
import 'package:tasks_app/features/auth/domain/auth_repository.dart';

/// Supabase-backed implementation of the domain [AuthRepository] contract.
///
/// Keeping Supabase types here prevents the rest of the app from depending on
/// the Supabase SDK.
class SupabaseAuthRepository implements AuthRepository {
  /// The injected Supabase client, which also makes this class easy to test.
  final SupabaseClient _client;

  /// Creates a repository that sends authentication requests through [_client].
  SupabaseAuthRepository(this._client);

  /// Converts a Supabase user into the app's smaller domain model.
  ///
  /// A missing Supabase user represents a signed-out app user.
  AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    return AppUser(id: user.id);
  }

  @override
  /// Reads the user from the session currently stored in the Supabase client.
  AppUser? get currentUser => _toAppUser(_client.auth.currentUser);

  @override
  /// Maps every Supabase auth event to an app user.
  ///
  /// The event's session is used instead of `currentUser` so sign-out emits
  /// `null` from the event that caused the change.
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.map(
      (event) => _toAppUser(event.session?.user),
    );
  }

  @override
  /// Asks Supabase to create an email/password account.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(email: email, password: password);
  }

  @override
  /// Asks Supabase to sign in an existing email/password account.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  /// Asks Supabase to remove the current session from this device.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
