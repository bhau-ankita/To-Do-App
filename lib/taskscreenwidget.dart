import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_4/apptask.dart';
import 'package:to_do_app_4/database_helper.dart';
import 'package:to_do_app_4/task.dart';
import 'package:to_do_app_4/taskbloc.dart';
import 'package:to_do_app_4/taskevent.dart';
import 'package:to_do_app_4/taskstate.dart';

class TaskScreen extends StatelessWidget {
  final TaskBloc taskBloc = TaskBloc(databaseHelper: DatabaseHelper());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => taskBloc,
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TasksLoaded) {
            return AppTask(
              tasks: state.tasks,
              addTask: (title, description, priority, dueDate) {
                taskBloc.add(TaskAdded(Task(
                  title: title,
                  description: description,
                  priority: priority,
                  dueDate: dueDate,
                  createdDate: DateTime.now(),
                )));
              },
              deleteTask: (index) {
                taskBloc.add(TaskDeleted(index));
              },
              toggleTaskDone: (index) {
                taskBloc.add(TaskToggleDone(index));
              },
              showUpcomingReminders: () {
                _showUpcomingReminders(context, state.tasks);
              },
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  void _showUpcomingReminders(BuildContext context, List<Task> tasks) {
    showDialog(
      context: context,
      builder: (context) {
        List<Task> upcomingTasks = tasks.where((task) {
          return task.dueDate.isAfter(DateTime.now()) &&
              task.dueDate.difference(DateTime.now()).inMinutes <= 1440;
        }).toList();

        return AlertDialog(
          title: const Text('Upcoming Reminders'),
          content: SizedBox(
            height: 300.0,
            width: 300.0,
            child: ListView.builder(
              itemCount: upcomingTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(upcomingTasks[index].title),
                  subtitle: Text(
                      'Due ${DateTime.now().difference(upcomingTasks[index].dueDate).inDays.abs()} days ago'),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
