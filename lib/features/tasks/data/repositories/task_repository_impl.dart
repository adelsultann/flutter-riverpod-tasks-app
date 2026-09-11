import 'package:tasks_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:tasks_app/features/tasks/data/models/task_model.dart';
import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _taskDataSource;
  // injected private dependency
  TaskRepositoryImpl(this._taskDataSource);

  @override
  Future<List<AppTask>> getTasks() async {
    final models = await _taskDataSource.getTasks();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AppTask> addTask(AppTask task) async {
    final model = await _taskDataSource.addTask(TaskModel.fromEntity(task));

    return model.toEntity();
  }

  @override
  Future<AppTask> updateTask(AppTask task) async {
    final model = await _taskDataSource.updateTask(TaskModel.fromEntity(task));
    return model.toEntity();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _taskDataSource.deleteTask(taskId);
  }

  @override
  Future<AppTask> setTaskCompletion(String taskId, bool isCompleted) async {
    final model = await _taskDataSource.setTaskCompletion(taskId, isCompleted);

    return model.toEntity();
  }
}
