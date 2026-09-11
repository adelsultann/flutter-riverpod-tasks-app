import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/features/tasks/application/task_providers.dart';
import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';

final taskControllerProvider =
    NotifierProvider<TaskController, AsyncValue<void>>(TaskController.new);

class TaskController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> addTask(String title, String? description) async {
    // 1. Set state to loading
    state = const AsyncLoading();

    // 2. Run the use case inside AsyncValue.guard and store the result locally
    //AsyncValue.guard gives
    // we assign the result locally so we can
    // inspect the result without touching the provider |
    // to run conditional logic based on the result
    final result = await AsyncValue.guard(() async {
      await ref.read(addTaskUseCaseProvider).call(title, description);
    });

    // 3. Assign the local result to state
    state = result;

    // 4. If successful, invalidate the tasksProvider so the UI refreshes
    if (result is AsyncData<void>) {
      // after we success and return the data we call another provider to refetch the data
      // so we get new list refresh
      ref.invalidate(tasksProvider);
    }
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await ref.read(deleteTaskUseCaseProvider).call(taskId);
    });

    state = result;

    if (result is AsyncData<void>) {
      ref.invalidate(tasksProvider);
    }
  }

  Future<void>updateTask(AppTask appTask) async {

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await ref.read(updateTaskUseCaseProvider).call(appTask);
    });

    state = result;

    if(result is AsyncData<void>){
      ref.invalidate(tasksProvider);
    } 

}


Future<void>setTaskCompletion(String taskId, bool isCompleted) async {
  state = const AsyncLoading();
  final result = await AsyncValue.guard(() async {
  await ref.read(setTaskCompletionUseCaseProvider).call(taskId,isCompleted);

  });

  state = result;

  if(result is AsyncData<void>){
    ref.invalidate(tasksProvider);
  }
}
}