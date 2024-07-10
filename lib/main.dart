import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_4/database_helper.dart'; // Import your DatabaseHelper class
import 'package:to_do_app_4/splashscreen.dart';
import 'package:to_do_app_4/task.dart';
import 'package:to_do_app_4/taskbloc.dart';
import 'package:to_do_app_4/taskscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();

  await dbHelper.initializeDatabase(); // Initialize the database

  // Insert dummy tasks
  await dbHelper.insertTask(Task(
    title: 'Task 1',
    description: 'Description for Task 1',
    priority: 'High',
    dueDate: DateTime.now().add(Duration(days: 3)),
    createdDate: DateTime.now(),
  ));
  await dbHelper.insertTask(Task(
    title: 'Task 2',
    description: 'Description for Task 2',
    priority: 'Medium',
    dueDate: DateTime.now().add(Duration(days: 5)),
    createdDate: DateTime.now(),
  ));

  // Retrieve tasks and print them
  List<Task> tasks = await dbHelper.getTasks();
  for (var task in tasks) {
    print('Task: ${task.title}, Priority: ${task.priority}');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.blue, // Button color
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      themeMode: ThemeMode.light, // Use system theme (light/dark)
      home: BlocProvider(
        create: (context) => TaskBloc(databaseHelper: DatabaseHelper()),
        child: SplashScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
