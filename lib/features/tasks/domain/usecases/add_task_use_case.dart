import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskUseCase {
  final TaskRepository _taskRepository;

  AddTaskUseCase(this._taskRepository);

  Future<AppTask> call(String title, String? description) {



    String titleValidator(String input) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) {
        throw ArgumentError('Title cannot be empty');
      }
      return trimmed;
    }

    String generateId() {
      const uuid = Uuid();

      final id = uuid.v4(); // Generate a unique ID

      return id;
    }

    final task = AppTask(
      id: generateId(), // Generate a unique ID for the new task
      title: titleValidator(title),
      description: description?.trim().isEmpty == true
          ? null
          : description?.trim(),
    );

    return _taskRepository.addTask(task);
  }
}
