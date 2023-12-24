import 'package:daily_planner/model/message_modell.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageService {
  final _supabase = Supabase.instance.client;

  Future<MessageModel?> createMessage(
      String title, int idSend, int idRecive) async {
    List<dynamic> createTodo = await _supabase
        .from('message')
        .insert(MessageModel(message: title, idSend: idSend, idRecive: idRecive)
            .toJson())
        .select();
    if (createTodo.isEmpty) {
      return null;
    } else {
      return MessageModel.fromJson(createTodo[0]);
    }
    // return null;
  }

  // Future<TaskOfTodoModel?> editTaskTodo(TaskOfTodoModel todoModel) async {
  //   List<dynamic> createTodo = await _supabase
  //       .from('task_of_todo')
  //       .update(todoModel.toJson())
  //       .eq("id", todoModel.id)
  //       .select();
  //   if (createTodo.isEmpty) {
  //     return null;
  //   } else {
  //     return TaskOfTodoModel.fromJson(createTodo[0]);
  //   }
  //   // return null;
  // }
  //
  // Future<TaskOfTodoModel?> deleteTaskTodo(int id) async {
  //   List<dynamic> getTd =
  //       await _supabase.from('task_of_todo').delete().eq('id', id).select();
  //   if (getTd.isEmpty) {
  //     return null;
  //   } else {
  //     return TaskOfTodoModel.fromJson(getTd[0]);
  //   }
  //   // return null;
  // }
  //
  // Future<bool> updateTaskTodo(TaskOfTodoModel todo) async {
  //   List<dynamic> getTd = await _supabase
  //       .from('task_of_todo')
  //       .update(todo.toJson())
  //       .eq('id', todo.id)
  //       .select();
  //   if (getTd.isEmpty) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
