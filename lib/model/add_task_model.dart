class Task {
  String id;
  String taskName;
  String description;
  String dateTime;
  String userId;

  Task({
    required this.id,
    required this.taskName,
    required this.description,
    required this.dateTime,
    required this.userId,
  });

  factory Task.fromMap(Map<String, dynamic> map, {required String id}) {
    return Task(
      id: id,
      taskName: map['taskName'] as String,
      description: map['description'] as String,
      dateTime: map['dateTime'] as String,
      userId: map['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'description': description,
      'dateTime': dateTime,
      'userId': userId,
    };
  }
}
