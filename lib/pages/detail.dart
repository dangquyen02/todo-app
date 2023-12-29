import 'package:daily_planner/model/task_of_todo.dart';
import 'package:daily_planner/model/todo_model.dart';
import 'package:daily_planner/model/user_model.dart';
import 'package:daily_planner/service/task_todo_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../service/todo_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.todo, required this.userModel});
  final UserModel userModel;
  final TodoModel todo;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TodoService _todoService = TodoService();
  final _supabase = Supabase.instance.client;
  final TaskTodoService _taskTodoService = TaskTodoService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  TodoModel? todoModel;

  // chọn ngày, giờ từ lịch
  TextEditingController _dateTimeController = TextEditingController();
  DateTime _datePicker = DateTime.now();
  late final Stream<List<TaskOfTodoModel>> _taskTodoStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoModel = widget.todo;
    titleController.text = todoModel!.title!;
    descriptionController.text = todoModel!.description!;
    _dateTimeController.text = todoModel!.time.toString();
    _datePicker = todoModel!.time!;
    _taskTodoStream = _supabase
        .from("task_of_todo")
        .stream(primaryKey: ['id'])
        .order("id", ascending: true)
        // .eq("id_todo", widget.todo)
        .map((maps) {
          return maps.map((map) {
            return TaskOfTodoModel.fromJson(map);
          }).toList();
        });
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _datePicker = combinedDateTime;
          _dateTimeController.text = combinedDateTime.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(36)),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.navigate_before),
                      ),
                    ),

                    const Spacer(),
                    if (!todoModel!.check!)

                      // edit todo
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16)),
                              ),
                              //backgroundColor: const Color(0xFF7DABF6),
                              backgroundColor: Colors.grey[50],
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(24),
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 48,
                                          child: TextField(
                                            controller: titleController,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ), // Chữ nhập vào màu trắng
                                            decoration: InputDecoration(
                                              labelText: 'Title',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Color(0x7F272727)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Ô nhập nội dung
                                        Container(
                                          height: 200,
                                          child: TextField(
                                            controller: descriptionController,
                                            maxLines: null,
                                            expands: true,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: 'Description',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Color(0x7F272727)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Ô chọn ngày giờ từ lịch
                                        Container(
                                          height: 48,
                                          child: TextField(
                                            readOnly: true,
                                            controller: _dateTimeController,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: 'Select Date and Time',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.black),
                                                onPressed: _pickDateTime,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Color(0x7F272727),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 48,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Back',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        //Color(0xFFF79E89),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.indigo,
                                                    // fixedSize:
                                                    //     Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 48,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    TodoModel? result =
                                                        await _todoService
                                                            .editTodo(TodoModel(
                                                      id: todoModel!.id,
                                                      title:
                                                          titleController.text,
                                                      description:
                                                          descriptionController
                                                              .text,
                                                      time: _datePicker,
                                                      userId:
                                                          widget.userModel.id!,
                                                    ));
                                                    if (result == null) {
                                                      print('dee');
                                                      return;
                                                    } else {
                                                      setState(() {
                                                        todoModel = result;
                                                      });

                                                      titleController.clear();
                                                      descriptionController
                                                          .clear();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Edit Todo',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        //Color(0xFFF79E89),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.indigo,
                                                    // fixedSize:
                                                    //     Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 24,
                          )),

                    // xóa todo
                    IconButton(
                        onPressed: () => showIncorrectCredentialsDialog(
                            context, 'Bạn có muốn xóa'),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        )),

                    // đánh dấu hoàn thành
                    IconButton(
                        onPressed: () => showCheckedDialog(
                            context,
                            todoModel!.check!
                                ? 'Bạn muốn hủy hoàn thành?'
                                : 'Bạn đã hoàn thành?'),
                        icon: Icon(
                          todoModel!.check! ? Icons.close : Icons.check,
                          size: 24,
                          color: Colors.blue,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nội dung: ',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            //color: Color(0xFFF76C6A),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Divider(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${todoModel!.description}",
                          style: const TextStyle(
                            color: Color(0xFF272727),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Thời gian: ${todoModel!.time}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // công việc con
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Công việc con:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            print('add');
                            showAddTask(context);
                          },
                          child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(36)),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Expanded(
                        child: StreamBuilder<List<TaskOfTodoModel>>(
                            stream: _taskTodoStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                List<TaskOfTodoModel> listTaskOfTodo =
                                    snapshot.data!;
                                List<TaskOfTodoModel> listTaskOfTodoResult = [];
                                for (var item in listTaskOfTodo) {
                                  if (item.idTodo == widget.todo.id) {
                                    listTaskOfTodoResult.add(item);
                                  }
                                }
                                return ListView.builder(
                                    itemCount: listTaskOfTodoResult.length,
                                    itemBuilder: ((context, index) {
                                      return Card(
                                        color: Colors.lightBlue[
                                            100], // Màu nền của từng công việc: const Color(0xFFF79E89)
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          trailing: SizedBox(
                                            width: 96,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: listTaskOfTodoResult[
                                                            index]
                                                        .check,
                                                    onChanged: (value) async {
                                                      listTaskOfTodoResult[
                                                              index]
                                                          .check = value;
                                                      _taskTodoService
                                                          .updateTaskTodo(
                                                              listTaskOfTodoResult[
                                                                  index]);
                                                      setState(() {});
                                                    }),
                                                IconButton(
                                                    onPressed: () =>
                                                        _taskTodoService
                                                            .deleteTaskTodo(
                                                                listTaskOfTodoResult[
                                                                        index]
                                                                    .id!),
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                              listTaskOfTodoResult[index]
                                                  .title),
                                          onTap: () {},
                                        ),
                                      );
                                    }));
                              }
                              print(snapshot.data);
                              return const Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator()));
                            }))
                  ],
                ))
                // Thêm các thông tin khác tùy ý
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showAddTask(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm công việc'),
          content: TextFormField(
            controller: _taskController,
            decoration: InputDecoration(
              fillColor: Colors.deepPurple,
              hoverColor: Colors.deepPurple,
              focusColor: Colors.deepPurple,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              hintText: 'Nhập tiêu đề',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                await _taskTodoService.createTaskTodo(
                    _taskController.text, todoModel!.id!);
                _taskController.clear();
                Navigator.pop(context);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showIncorrectCredentialsDialog(
      BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () {
                _todoService.deleteTodo(todoModel!.id!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCheckedDialog(BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                todoModel!.check = !todoModel!.check!;
                bool result = await _todoService.updateTodo(todoModel!);
                print(result);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('xác nhận'),
            ),
          ],
        );
      },
    );
  }
}
