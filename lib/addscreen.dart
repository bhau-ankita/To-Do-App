import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_4/task.dart';
import 'package:to_do_app_4/tasklistscreen.dart';

class AppTask extends StatefulWidget {
  final List<Task> tasks;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  String selectedPriority;
  final DateTime selectedDate;
  final Function(String, String, String, DateTime) addTask;
  final Function(int) deleteTask;
  final Function(int) toggleTaskDone;
  final Function(BuildContext) selectDate;
  final Function() showUpcomingReminders;

  AppTask({
    Key? key,
    required this.tasks,
    required this.titleController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.selectedDate,
    required this.addTask,
    required this.deleteTask,
    required this.toggleTaskDone,
    required this.selectDate,
    required this.showUpcomingReminders,
  }) : super(key: key);

  @override
  _AppTaskState createState() => _AppTaskState();
}

class _AppTaskState extends State<AppTask> {
  int _selectedIndex = 0;

  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _buildTaskForm(),
      TaskListScreen(
        tasks: widget.tasks,
        deleteTask: widget.deleteTask,
        toggleTaskDone: widget.toggleTaskDone,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTaskForm() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset(
                  'assets/images/To-Do-App-Logo.png', // Replace with your image path
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: widget.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: widget.descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: widget.selectedPriority,
                    items: ['Low', 'Medium', 'High'].map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.selectedPriority = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Priority Level',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Due Date: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => widget.selectDate(context),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.titleController.text.isNotEmpty &&
                      widget.descriptionController.text.isNotEmpty) {
                    widget.addTask(
                      widget.titleController.text,
                      widget.descriptionController.text,
                      widget.selectedPriority,
                      widget.selectedDate,
                    );
                    widget.titleController.clear();
                    widget.descriptionController.clear();
                    _onItemTapped(
                        1); // Switch to task list screen after adding task
                  } else {
                    print('Empty fields');
                  }
                },
                style: ElevatedButton.styleFrom(
                  //primary: Colors.blue, // Button color
                  //onPrimary: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: widget.showUpcomingReminders,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF3D424A),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
