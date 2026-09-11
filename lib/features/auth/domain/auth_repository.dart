import 'package:tasks_app/features/auth/domain/app_user.dart';

/// The domain contract for authentication.
///
/// Application and presentation code use this interface, while the data layer
/// decides how it is implemented (Supabase in this app).
abstract interface class AuthRepository {
  /// Returns the client session's user, or `null` when there is no session.
  AppUser? get currentUser;

  /// Emits the signed-in user after each auth event, or `null` after sign-out.
  // stream is used to listen for changes in the authentication state,
  // such as sign-in or sign-out events.
  Stream<AppUser?> authStateChanges();

  /// Creates an account using an email address and password.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Starts a session for an existing account using an email and password.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Ends the current session on this device.
  Future<void> signOut();
}
