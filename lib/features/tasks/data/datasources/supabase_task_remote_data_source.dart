import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:tasks_app/features/tasks/data/models/task_model.dart';

class SupabaseTaskRemoteDataSource implements TaskRemoteDataSource {
  final SupabaseClient _client;

  SupabaseTaskRemoteDataSource(this._client);

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await _client
        .from('tasks')
        .select('id, title, description, is_completed')
        .order('created_at', ascending: false);
    return response.map<TaskModel>((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final response = await _client
        .from('tasks')
        .insert(task.toJson())
        .select()
        .single();
    return TaskModel.fromJson(response);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _client
        .from('tasks')
        .update({'title': task.title, 'description': task.description})
        .eq('id', task.id)
        .select()
        .single();
    return TaskModel.fromJson(response);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _client.from('tasks').delete().eq('id', taskId).select().single();
  }

  @override
  Future<TaskModel> setTaskCompletion(String taskId, bool isCompleted) async {
    final response = await _client
        .from('tasks')
        .update({'is_completed': isCompleted})
        .eq('id', taskId)
        .select()
        .single();

    return TaskModel.fromJson(response);
  }
}
