import 'package:tasks_app/features/auth/domain/app_user.dart';
import 'package:tasks_app/features/auth/domain/auth_repository.dart';

/// Exposes session changes without leaking a data-layer implementation upward.
class WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<AppUser?> call() => _repository.authStateChanges();
}
