import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_4/task.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(int) deleteTask;
  final Function(int) toggleTaskDone;

  TaskListScreen({
    required this.tasks,
    required this.deleteTask,
    required this.toggleTaskDone,
  });

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Sorting the tasks by priority and filtering by search query
    List<Task> sortedTasks = List.from(widget.tasks);
    sortedTasks.sort((a, b) {
      return _priorityValue(a.priority).compareTo(_priorityValue(b.priority));
    });

    List<Task> filteredTasks = sortedTasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do-App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50.0,
              width: double.infinity, // Takes the full width available
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Example background color
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  Task task = filteredTasks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (_) => widget.deleteTask(index),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                    ),
                    direction: DismissDirection.endToStart,
                    child: Card(
                      color: Colors.white54,
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${task.description}'),
                            Text('Priority: ${task.priority}'),
                            Text(
                              'Due Date: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate)}',
                            ),
                            Text(
                              'Created Date: ${DateFormat('yyyy-MM-dd HH:mm').format(task.createdDate)}',
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: task.isDone ?? false,
                          onChanged: (value) => widget.toggleTaskDone(index),
                        ),
                        onLongPress: () => widget.deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Convert priority string to a value for comparison
  int _priorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 1;
      case 'Medium':
        return 2;
      case 'Low':
        return 3;
      default:
        return 4;
    }
  }
}
