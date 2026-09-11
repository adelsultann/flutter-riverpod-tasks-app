import 'package:tasks_app/features/auth/domain/auth_repository.dart';

/// Represents the domain action of creating an email/password account.
class SignUpWithEmailUseCase {
  final AuthRepository _repository;

  SignUpWithEmailUseCase(this._repository);

  Future<void> call({required String email, required String password}) {
    return _repository.signUpWithEmail(email: email, password: password);
  }
}
