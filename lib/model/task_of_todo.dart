class TaskOfTodoModel {
  int? id;
  int? idTodo;
  String title;
  bool? check;
  TaskOfTodoModel({
    this.id,
    this.idTodo,
    required this.title,
    this.check,
  });

  factory TaskOfTodoModel.fromJson(Map<String, dynamic> json) =>
      TaskOfTodoModel(
        id: json['id'],
        title: json['title'],
        idTodo: json['id_todo'],
        check: json['check'] ?? false,
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id_todo': idTodo,
      'check': check ?? false,
    };
  }
}
