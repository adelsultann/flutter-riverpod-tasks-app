



import 'package:tasks_app/features/tasks/data/models/task_model.dart';



abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<TaskModel> setTaskCompletion(String taskId, bool isCompleted);
}