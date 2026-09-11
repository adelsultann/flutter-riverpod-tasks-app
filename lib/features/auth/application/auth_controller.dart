import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/features/auth/application/auth_providers.dart';

/// Holds the loading or error state of an authentication command.
///
/// Screens watch this provider to disable controls during a request and show
/// errors. The separate `authStateProvider` exposes session changes.
final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);

/// Coordinates user-triggered authentication commands for the UI.
class AuthController extends Notifier<AsyncValue<void>> {
  @override
  /// Sets the initial idle state before the user runs an auth command.
  AsyncValue<void> build() => const AsyncData(null);

  /// Signs in and records either a loading state, success, or caught error.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Sets the state to loading before starting the sign-in process.
    state = const AsyncLoading();
    // AsyncValue.guard converts a thrown exception into AsyncError, so the
    // presentation layer can display it without try/catch in every screen.
    state = await AsyncValue.guard(
      () => ref
          .read(signInWithEmailUseCaseProvider)
          .call(email: email, password: password),
    );
  }

  /// Creates an account and records either a loading state, success, or error.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(signUpWithEmailUseCaseProvider)
          .call(email: email, password: password),
    );
  }

  /// Ends the session and records either a loading state, success, or error.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(signOutUseCaseProvider).call(),
    );
  }
}
