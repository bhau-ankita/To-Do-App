import 'package:equatable/equatable.dart';

import 'package:to_do_app_4/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;

  TasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() => 'TasksLoaded { tasks: $tasks }';
}
