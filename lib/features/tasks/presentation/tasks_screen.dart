import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/app/router/routes.dart';
import 'package:tasks_app/features/tasks/application/task_controller.dart';
import 'package:tasks_app/features/tasks/application/task_providers.dart';
import 'package:tasks_app/features/tasks/domain/entities/app_task.dart';
import 'package:tasks_app/app/theme/theme_mode_controller.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_6),
            itemBuilder: (context) => const [
              PopupMenuItem(value: ThemeMode.system, child: Text('System')),
              PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
            //The callback’s
            //themeMode parameter is inferred as ThemeMode
            //from PopupMenuButton<ThemeMode>.
            onSelected: (themeMode) {
              ref.read(themeModeProvider.notifier).setThemeMode(themeMode);
            },
          ),
        ],
      ),

      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("an Error occurred: $err", textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // invalidate marks the provider’s state stale and rebuild the widget
                  ref.invalidate(tasksProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text("No task yet"));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final bool isSelected = task.isCompleted;
              return ListTile(
                trailing: IconButton(
                  onPressed: () => {_showConfirmDialog(context, ref, task)},
                  icon: Icon(Icons.delete),
                ),
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (bool? newValue) {
                    if (newValue == null) return;

                    ref
                        .read(taskControllerProvider.notifier)
                        .setTaskCompletion(task.id, newValue);
                  },
                ),
                title: (Text(task.title)),
                subtitle: Text(task.description ?? ''),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {const CreateTaskRoute().push(context)},
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _showConfirmDialog(
  BuildContext context,
  WidgetRef ref,
  AppTask task,
) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text("Are you Sure You Want to Delete "),
        content: Text(task.title),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Closes the dialog
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              // Perform actions here
              ref.read(taskControllerProvider.notifier).deleteTask(task.id);
              Navigator.of(context).pop(); // Closes the dialog
            },
          ),
        ],
      );
    },
  );
}
