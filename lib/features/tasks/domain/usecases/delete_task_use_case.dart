import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  Future<void> call(String taskId) {
    if (taskId.trim().isEmpty) {
      throw ArgumentError('Task ID cannot be empty');
    }

    return _taskRepository.deleteTask(taskId);
  }
}
