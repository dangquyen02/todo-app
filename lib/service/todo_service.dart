import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/todo_model.dart';

class TodoService {
  final _supabase = Supabase.instance.client;

  Future<TodoModel?> createTodo(
      String title, String description, DateTime time, int user_id) async {
    List<dynamic> createTodo = await _supabase
        .from('todo')
        .insert(TodoModel(
                title: title,
                description: description,
                time: time,
                userId: user_id)
            .toJson())
        .select();
    if (createTodo.isEmpty) {
      return null;
    } else {
      return TodoModel.fromJson(createTodo[0]);
    }
    // return null;
  }

  Future<TodoModel?> editTodo(TodoModel todoModel) async {
    List<dynamic> createTodo = await _supabase
        .from('todo')
        .update(todoModel.toJson())
        .eq("id", todoModel.id)
        .select();
    if (createTodo.isEmpty) {
      return null;
    } else {
      return TodoModel.fromJson(createTodo[0]);
    }
    // return null;
  }

  Future<TodoModel?> deleteTodo(int id) async {
    List<dynamic> getTd =
        await _supabase.from('todo').delete().eq('id', id).select();
    if (getTd.isEmpty) {
      return null;
    } else {
      return TodoModel.fromJson(getTd[0]);
    }
    // return null;
  }
}
