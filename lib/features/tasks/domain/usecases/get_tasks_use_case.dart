



import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  // this is constructor dependency it is what the class needs to do its job, 

  final TaskRepository _taskRepository;
// this is dependency injection, we are injecting the repository 
//into the use case, so that the use case can use the repository to get the tasks from the data source. This is a good practice because it makes the use case more testable and more flexible. We can easily swap out the repository for a different implementation if we want to change the data source.
  // injecting the dependency because the dependency is given not
  // created inside the class, this is a good practice because it makes the class more testable and more flexible. We can easily swap out the repository for a different implementation if we want to change the data source.
  GetTasksUseCase(this._taskRepository);

  Future<List<AppTask>> call() async {
    return await _taskRepository.getTasks();
  }
}

//why should the use case call the repository instead of the UI calling it directly?

// UI is not supposed to know how data fetched | the UI should only trigger business action
// use case keep the architecture clean and flexible 