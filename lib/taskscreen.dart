import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:to_do_app_4/addscreen.dart';
import 'package:to_do_app_4/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime _selectedDate = DateTime.now();
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    //tz.initializeTimeZones();
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  void _addTask(
      String title, String description, String priority, DateTime dueDate) {
    setState(() {
      _tasks.add(Task(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
        createdDate: DateTime
            .now(), // Assuming you want to set createdDate when adding a new task
      ));

      _sortTasksByDueDate();
      _sortTasksByCreationDate();
      _scheduleNotification(title, dueDate);
    });
  }

  void _sortTasksByDueDate() {
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void _sortTasksByCreationDate() {
    _tasks.sort((a, b) => a.createdDate.compareTo(b.createdDate));
  }

  void _toggleTaskDone(int index) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isDone: true);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _scheduleNotification(String taskTitle, DateTime dueDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Set reminder for 10 minutes before the task's due date
    final reminderTime = dueDate.subtract(const Duration(minutes: 10));

    await _flutterLocalNotificationsPlugin!.zonedSchedule(
      _tasks.length, // Notification ID
      'Task Reminder',
      'Your task "$taskTitle" is due soon!',
      tz.TZDateTime.from(reminderTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void _showUpcomingReminders() {
    showDialog(
      context: context,
      builder: (context) {
        List<Task> upcomingTasks = _tasks.where((task) {
          return task.dueDate.isAfter(DateTime.now()) &&
              task.dueDate.difference(DateTime.now()).inMinutes <=
                  1440; // Tasks due in the next 24 hours
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
                      'Due Date: ${DateFormat('yyyy-MM-dd HH:mm').format(upcomingTasks[index].dueDate)}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppTask(
      tasks: _tasks,
      titleController: _titleController,
      descriptionController: _descriptionController,
      selectedPriority: _selectedPriority,
      selectedDate: _selectedDate,
      addTask: _addTask,
      deleteTask: _deleteTask,
      toggleTaskDone: _toggleTaskDone,
      selectDate: _selectDate,
      showUpcomingReminders: _showUpcomingReminders,
    );
  }
}
