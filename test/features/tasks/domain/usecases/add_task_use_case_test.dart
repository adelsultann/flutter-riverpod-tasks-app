import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks/domain/usecases/add_task_use_case.dart';

class FakeTaskRepository implements TaskRepository {
  AppTask? addedTask;

  @override
  Future<AppTask> addTask(AppTask task) async {
    addedTask = task;
    return task;
  }

  @override
  Future<void> deleteTask(String taskId) {
    throw UnimplementedError();
  }

  @override
  Future<List<AppTask>> getTasks() {
    throw UnimplementedError();
  }

  @override
  Future<AppTask> setTaskCompletion(String taskId, bool isCompleted) {
    throw UnimplementedError();
  }

  @override
  Future<AppTask> updateTask(AppTask task) {
    throw UnimplementedError();
  }
}


void main() {
  group('AddTaskUseCase', () {
    late FakeTaskRepository repository;
    late AddTaskUseCase useCase;

    setUp(() {
      repository = FakeTaskRepository();
      useCase = AddTaskUseCase(repository);
    });

    test('trims title and description before adding the task', () async {
      await useCase('  Buy milk  ', '  Two bottles  ');

      expect(repository.addedTask, isNotNull);
      expect(repository.addedTask!.title, 'Buy milk');
      expect(repository.addedTask!.description, 'Two bottles');
    });
  });
}