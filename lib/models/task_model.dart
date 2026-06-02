class Task {
  int? id;
  int? userId;
  String title;
  String description;
  String priority;
  String? dueDate;
  int isCompleted;

  Task({
    this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.isCompleted = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'],
    );
  }
}
