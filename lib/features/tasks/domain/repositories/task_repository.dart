import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';

abstract class TaskRepository {
  // different between Future<AppTask> and Future<void>
  // The deeper architectural principle
  // Commands that modify state → return the updated domain entity = Future<List<AppTask>>
  // Commands that remove state → return void = Future<void>
  // Queries → return domain entities = Future<List<AppTask>>

  Future<List<AppTask>> getTasks();

  Future<AppTask> addTask(AppTask task);

  Future<AppTask> updateTask(AppTask task);

  Future<void> deleteTask(String taskId);

  Future<AppTask> setTaskCompletion(String taskId, bool isCompleted);
}
