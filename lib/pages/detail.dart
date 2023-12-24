import 'dart:html';

import 'package:daily_planner/model/todo_model.dart';
import 'package:daily_planner/model/user_model.dart';
import 'package:daily_planner/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner/pages/edit.dart';

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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TodoModel? todoModel;
  // chọn ngày, giờ từ lịch
  TextEditingController _dateTimeController = TextEditingController();
  DateTime _datePicker = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoModel = widget.todo;
    titleController.text = todoModel!.title!;
    descriptionController.text = todoModel!.description!;
    _dateTimeController.text = todoModel!.time.toString();
    _datePicker = todoModel!.time!;
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
    return Scaffold(
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
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16)),
                          ),
                          backgroundColor: const Color(0xFFF79A89),
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(24),
                              height: MediaQuery.of(context).size.height * 0.8,
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
                                            color: Colors
                                                .white), // Chữ nhập vào màu trắng
                                        decoration: InputDecoration(
                                          labelText: 'Title',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
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
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
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
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          labelText: 'Select Date and Time',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.white),
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
                                                    color: Color(0xFFF79E89),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                // fixedSize:
                                                //     Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                                                shape: RoundedRectangleBorder(
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
                                                  title: titleController.text,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  time: _datePicker,
                                                  userId: widget.userModel.id!,
                                                ));
                                                if (result == null) {
                                                  print('dee');
                                                  return;
                                                } else {
                                                  setState(() {
                                                    todoModel = result;
                                                  });

                                                  titleController.clear();
                                                  descriptionController.clear();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text(
                                                'Edit Todo',
                                                style: TextStyle(
                                                    color: Color(0xFFF79E89),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                // fixedSize:
                                                //     Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                                                shape: RoundedRectangleBorder(
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
                        size: 24,
                      )),
                  IconButton(
                      onPressed: () => showIncorrectCredentialsDialog(
                          context, 'Bạn có muốn xóa'),
                      icon: const Icon(
                        Icons.delete,
                        size: 24,
                      ))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nội dung: ',
                      style: const TextStyle(
                        color: Color(0xFFF76C6A),
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "${todoModel!.description}",
                      style: const TextStyle(
                        color: Color(0xFF272727),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Thời gian: ${todoModel!.time}',
                      style: const TextStyle(
                        color: Color(0xFF272727),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
              // Thêm các thông tin khác tùy ý
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showIncorrectCredentialsDialog(
      BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
            TextButton(
              onPressed: () {
                _todoService.deleteTodo(todoModel!.id!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('xác nhận'),
            ),
          ],
        );
      },
    );
  }
}
