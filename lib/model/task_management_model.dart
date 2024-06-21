class Task {
  String id;
  String taskName;
  String description;
  String dateTime;

  Task({
    required this.id,
    required this.taskName,
    required this.description,
    required this.dateTime,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String? ?? '', // Provide a default value or handle null appropriately
      taskName: map['taskName'] as String? ?? '', // Provide a default value or handle null appropriately
      description: map['description'] as String? ?? '', // Provide a default value or handle null appropriately
      dateTime: map['dateTime'] as String? ?? '', // Provide a default value or handle null appropriately
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'description': description,
      'dateTime': dateTime,
    };
  }
}