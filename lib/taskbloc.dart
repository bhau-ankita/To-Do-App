import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:to_do_app_4/database_helper.dart';
import 'package:to_do_app_4/task.dart';
// Ensure Task class is imported
import 'package:to_do_app_4/taskstate.dart'; // Assuming TaskState and TasksLoaded are defined here
import 'package:to_do_app_4/taskevent.dart'; // Assuming TaskEvent classes are defined here

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  late DatabaseHelper dbHelper;

  TaskBloc({required DatabaseHelper databaseHelper}) : super(TaskInitial()) {
    dbHelper = DatabaseHelper();
    _loadTasks();
  }

  void _loadTasks() {
    dbHelper.getTasks().then((tasks) {
      //add(TasksLoaded(tasks));
    });
  }

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is TaskAdded) {
      _addTask(event.task);
    } else if (event is TaskDeleted) {
      _deleteTask(event.index);
    } else if (event is TaskUpdated) {
      _updateTask(event.index, event.updatedTask);
    } else if (event is TaskToggleDone) {
      _toggleTaskDone(event.index);
    }
  }

  void _addTask(Task task) {
    dbHelper.insertTask(task).then((_) {
      _loadTasks();
    });
  }

  void _deleteTask(int index) {
    final state = this.state;
    if (state is TasksLoaded) {
      final taskToDelete = state.tasks[index];
      dbHelper.deleteTask(taskToDelete.id!).then((_) {
        _loadTasks();
      });
    }
  }

  void _updateTask(int index, Task updatedTask) {
    final state = this.state;
    if (state is TasksLoaded) {
      dbHelper.updateTask(updatedTask).then((_) {
        _loadTasks();
      });
    }
  }

  void _toggleTaskDone(int index) {
    final state = this.state;
    if (state is TasksLoaded) {
      Task taskToUpdate =
          state.tasks[index].copyWith(isDone: !state.tasks[index].isDone);
      dbHelper.updateTask(taskToUpdate).then((_) {
        _loadTasks();
      });
    }
  }
}
