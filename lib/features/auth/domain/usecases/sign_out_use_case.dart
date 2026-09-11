import 'package:tasks_app/features/auth/domain/auth_repository.dart';

/// Represents the domain action of ending the current session.
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}
