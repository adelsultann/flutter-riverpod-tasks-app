import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks_app/features/tasks/data/datasources/supabase_task_remote_data_source.dart';
import 'package:tasks_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:tasks_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks_app/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks_app/features/tasks/domain/usecases/get_tasks_use_case.dart';
import 'package:tasks_app/features/tasks/domain/usecases/set_task_completion_use_case.dart';
import 'package:tasks_app/features/tasks/domain/usecases/update_task_use_case.dart';

// give me an object that can talk to the data layer
final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return SupabaseTaskRemoteDataSource(Supabase.instance.client);
});

// give me an object that can talk to the domain layer
// ref.watch is to subscribe to provider
// we use Provider when the data is synchronous
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dataSource = ref.watch(taskRemoteDataSourceProvider);
  return TaskRepositoryImpl(dataSource);
});

// give me an object that can perform  an action
final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetTasksUseCase(repository);
});

final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return AddTaskUseCase(repository);
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return UpdateTaskUseCase(repository);
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return DeleteTaskUseCase(repository);
});

final setTaskCompletionUseCaseProvider = Provider<SetTaskCompletionUseCase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return SetTaskCompletionUseCase(repository);
});

/// The task list for the current screen. It loads when first watched and can
/// be refreshed by invalidating this provider after a successful mutation.
/// FutureProvider is used when the data us Asynchronous
/// used for for Read-Only / Get Requests
final tasksProvider = FutureProvider<List<AppTask>>((ref) async {
  final getTasks = ref.watch(getTasksUseCaseProvider);
  return getTasks();
});
