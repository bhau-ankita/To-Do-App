import 'package:to_do_app_4/task.dart';

abstract class TaskEvent {}

class TaskAdded extends TaskEvent {
  final Task task;

  TaskAdded(this.task);
}

class TaskDeleted extends TaskEvent {
  final int index;

  TaskDeleted(this.index);
}

class TaskUpdated extends TaskEvent {
  final int index;
  final Task updatedTask;

  TaskUpdated(this.index, this.updatedTask);
}

class TaskToggleDone extends TaskEvent {
  final int index;

  TaskToggleDone(this.index);
}

class FetchTasks extends TaskEvent {}
