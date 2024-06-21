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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'description': description,
      'dateTime': dateTime,
    };
  }
}