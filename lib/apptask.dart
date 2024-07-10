import 'package:flutter/material.dart';
import 'package:to_do_app_4/task.dart';
import 'package:to_do_app_4/tasklistscreen.dart';
import 'package:to_do_app_4/taskscreen.dart';

typedef AddTaskCallback = void Function(
    String title, String description, String priority, DateTime dueDate);
typedef DeleteTaskCallback = void Function(int index);
typedef ToggleTaskDoneCallback = void Function(int index);
typedef ShowUpcomingRemindersCallback = void Function();

class AppTask extends StatelessWidget {
  final List<Task> tasks;
  final AddTaskCallback addTask;
  final DeleteTaskCallback deleteTask;
  final ToggleTaskDoneCallback toggleTaskDone;
  final ShowUpcomingRemindersCallback showUpcomingReminders;

  AppTask({
    required this.tasks,
    required this.addTask,
    required this.deleteTask,
    required this.toggleTaskDone,
    required this.showUpcomingReminders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TaskListScreen(
              tasks: tasks,
              deleteTask: deleteTask,
              toggleTaskDone: toggleTaskDone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(),
                  ),
                );
              },
              child: const Text('Add Task'),
            ),
          ),
          ElevatedButton(
            onPressed: showUpcomingReminders,
            child: const Text('View Upcoming Reminders'),
          ),
        ],
      ),
    );
  }
}
