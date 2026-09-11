import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks_app/features/auth/data/supabase_auth_repository.dart';
import 'package:tasks_app/features/auth/domain/app_user.dart';
import 'package:tasks_app/features/auth/domain/auth_repository.dart';
import 'package:tasks_app/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:tasks_app/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:tasks_app/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:tasks_app/features/auth/domain/usecases/watch_auth_state_use_case.dart';

/// Provides the domain repository contract backed by the Supabase data-layer
/// implementation. This is the composition point where the concrete service
/// is chosen; controllers and screens only see domain types.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
});

/// Each provider builds one domain action from the repository contract.
/// Controllers read these actions instead of reaching into the data layer.
final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>((ref) {
  return SignInWithEmailUseCase(ref.watch(authRepositoryProvider));
});

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>((ref) {
  return SignUpWithEmailUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>((ref) {
  return WatchAuthStateUseCase(ref.watch(authRepositoryProvider));
});

/// Exposes the current user to Riverpod consumers.
///
/// Its `AsyncValue` is loading while Supabase restores the initial session,
/// contains an [AppUser] when signed in, and contains `null` when signed out.
// we subscribe to the AppUser from the domain so we can anywhere in the app
// watch the authStateChanges
final authStateProvider = StreamProvider<AppUser?>((ref) {
  // The stream provider owns session observation; the router watches this
  // state to decide whether a route is public, loading, or authenticated.
  final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);
  return watchAuthState();
});
