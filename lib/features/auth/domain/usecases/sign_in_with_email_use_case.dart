import 'package:tasks_app/features/auth/domain/auth_repository.dart';

/// Represents the domain action of starting an email/password session.
class SignInWithEmailUseCase {
  final AuthRepository _repository;

  SignInWithEmailUseCase(this._repository);

  /// Delegates the authentication request through the domain contract.
  ///
  /// The application layer depends on this use case, not on Supabase or a
  /// concrete repository implementation.
  Future<void> call({required String email, required String password}) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
