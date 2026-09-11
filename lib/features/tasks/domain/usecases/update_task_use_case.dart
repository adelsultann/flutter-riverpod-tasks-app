import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository _taskRepository;

  UpdateTaskUseCase(this._taskRepository);

  Future<AppTask> call(AppTask task) {
    final normalizedTitle = _validateTitle(task.title);
    final normalizedDescription = _normalizeDescription(task.description);


    // Create a new instance of AppTask with the updated values
    // we use copyWith to create a new instance of AppTask with the updated values, while keeping the other properties unchanged. This is a common pattern in
    // immutable data structures, where we create 
    //a new instance instead of modifying the existing one.
    //copyWith keeps all fields except the ones you override.
    final updatedTask = task.copyWith(
      title: normalizedTitle,
      description: normalizedDescription,
    );

    return _taskRepository.updateTask(updatedTask);
  }

  String _validateTitle(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    return trimmed;
  }

  String? _normalizeDescription(String? input) {
    if (input == null) return null;
    final trimmed = input.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
