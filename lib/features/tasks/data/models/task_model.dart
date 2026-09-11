import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
abstract class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    // Jsonkey is used to tell JSON serialization that the
    // supabase column name is different from the dart field name
    //In this case, the column name is is_completed,
    //but th dart field name is isCompleted. This is
    // because the dart naming convention is camelCase, while the supabase naming convention is snake_case.

    @JsonKey(name: 'is_completed') 
    @Default(false) 
    bool isCompleted,
  }) = _TaskModel;

  // Why the private constructor? It lets Freezed-generated subclasses inherit
  //concrete methods
  //like toEntity(), while the factory constructor still creates the immutable model
  //allows concrete methods such as toEntity() to be inherited by the generated class.
  const TaskModel._(); // Private constructor for freezed

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

// custom instance method to convert TaskModel to AppTask
// Supabase JSON → TaskModel → AppTask → UI/domain
  AppTask toEntity() {
    return AppTask(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
  // custom method to convert AppTask to TaskModel
  // UI/domain → AppTask → TaskModel → Supabase JSON
  factory TaskModel.fromEntity(AppTask task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    );
  }
}
