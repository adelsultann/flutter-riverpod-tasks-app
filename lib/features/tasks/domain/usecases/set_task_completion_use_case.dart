import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';

class SetTaskCompletionUseCase {
  final TaskRepository _taskRepository;

  SetTaskCompletionUseCase(this._taskRepository);

  Future<AppTask> call(String taskId, bool isCompleted) {
    if (taskId.trim().isEmpty) {
      throw ArgumentError('Task ID cannot be empty');
    }

    return _taskRepository.setTaskCompletion(taskId, isCompleted);
  }
}
