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
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  Task task = filteredTasks[index];
                  int taskIndex = widget.tasks.indexOf(task);
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (_) => widget.deleteTask(taskIndex),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                    ),
                    direction: DismissDirection.endToStart,
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: _priorityIndicator(task.priority),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: task.isDone ?? false
                                ? Colors.grey
                                : Colors.black,
                            decoration: task.isDone ?? false
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
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
                        trailing: IconButton(
                          icon: Icon(
                            task.isDone ?? false
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: task.isDone ?? false
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.toggleTaskDone(taskIndex);
                            });
                          },
                        ),
                        onLongPress: () => widget.deleteTask(taskIndex),
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

  // Priority indicator
  Widget _priorityIndicator(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.red;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      case 'Low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      width: 10,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
    );
  }
}
