class TodoModel {
  int? id;
  String? title;
  String? description;
  DateTime? time;
  String? image;
  int? userId;
  bool? check;

  TodoModel(
      {this.id,
      this.title,
      this.description,
      this.time,
      this.userId,
      this.check});

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: DateTime.parse(json['time']),
      userId: json['user_id'],
      check: json['check']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': time == null
          ? DateTime.now().toIso8601String()
          : time!.toIso8601String(),
      'user_id': userId,
      'check': check ?? false
    };
  }
}
