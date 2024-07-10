class Task {
  int? id;
  String title;
  String description;
  String priority;
  DateTime dueDate;
  DateTime createdDate;
  bool isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.createdDate,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'due_date': dueDate.millisecondsSinceEpoch,
      'created_date': createdDate.millisecondsSinceEpoch,
      'is_done': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['due_date']),
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['created_date']),
      isDone: map['is_done'] == 1,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
    DateTime? createdDate,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdDate: createdDate ?? this.createdDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
