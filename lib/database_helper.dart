import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'task.dart'; // Import your Task model

class DatabaseHelper {
  late Database _database;

  Database get database => _database;

  Future<int> insertTask(Task task) async {
    try {
      await _openDatabaseIfNeeded();
      int result = await _database.insert('tasks', task.toMap());
      print('Task inserted with id: $result');
      return result;
    } catch (e) {
      print('Error inserting task: $e');
      return -1; // Return -1 or another error code to indicate failure.
    }
  }

  Future<void> _openDatabaseIfNeeded() async {
    if (_database == null) {
      await initializeDatabase();
    }
  }

  Future<void> initializeDatabase() async {
    try {
      String path = await getDatabasesPath();
      String databasePath = join(path, 'tasks.db');

      _database = await openDatabase(databasePath, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            description TEXT, 
            priority TEXT, 
            due_date INTEGER, 
            created_date INTEGER, 
            is_done INTEGER
          )
        ''');
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute('DROP TABLE IF EXISTS tasks');
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            description TEXT, 
            priority TEXT, 
            due_date INTEGER, 
            created_date INTEGER, 
            is_done INTEGER
          )
        ''');
      });

      print('Database initialized');
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      await _openDatabaseIfNeeded();
      final List<Map<String, dynamic>> tasksMapList =
          await _database.query('tasks');
      return List.generate(tasksMapList.length, (index) {
        return Task.fromMap(tasksMapList[index]);
      });
    } catch (e) {
      print('Error getting tasks: $e');
      return []; // Return an empty list in case of error.
    }
  }

  Future<int> updateTask(Task task) async {
    try {
      await _openDatabaseIfNeeded();
      int result = await _database
          .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
      print('Task updated with id: ${task.id}');
      return result;
    } catch (e) {
      print('Error updating task: $e');
      return -1; // Return -1 or another error code to indicate failure.
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      await _openDatabaseIfNeeded();
      int result =
          await _database.delete('tasks', where: 'id = ?', whereArgs: [id]);
      print('Task deleted with id: $id');
      return result;
    } catch (e) {
      print('Error deleting task: $e');
      return -1; // Return -1 or another error code to indicate failure.
    }
  }

  Future<void> close() async {
    try {
      if (_database != null && _database.isOpen) {
        await _database.close();
        print('Database closed');
      }
    } catch (e) {
      print('Error closing database: $e');
    }
  }
}
