

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_task.freezed.dart';

@freezed
abstract class AppTask with _$AppTask {
  const factory AppTask({
    required String id,
    required String title,
    String? description,
    @Default(false) bool isCompleted,

  }) = _AppTask;

  
}