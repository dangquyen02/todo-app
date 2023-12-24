import 'package:flutter/material.dart';
import 'package:daily_planner/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daily_planner/service/todo_service.dart';
import 'package:daily_planner/service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//void main() => runApp(MyApp());

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TodoService _todoService = TodoService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // chọn ngày, giờ từ lịch
  TextEditingController _dateTimeController = TextEditingController();
  DateTime _datePicker = DateTime.now();
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
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          //color: Color(0xFFF79E89),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                // Ô nhập title
                Container(
                  height: 48,
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(
                        color: Colors.black), // Chữ nhập vào màu trắng
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.black), //.white
                      border: OutlineInputBorder(
                        borderSide:
                            //BorderSide(width: 1, color: Color(0x7F272727)),
                            BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Ô nhập nội dung
                Container(
                  height: 350,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    expands: true,
                    //style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      //labelStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Ô chọn ngày giờ từ lịch
                Container(
                  height: 48,
                  child: TextField(
                    readOnly: true,
                    controller: _dateTimeController,
                    //style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Select Date and Time',
                      labelStyle: TextStyle(color: Colors.black), //.white
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: Colors.blueAccent), //.white
                        onPressed: _pickDateTime,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0x7F272727),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                Container(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _todoService.createTodo(
                        titleController.text,
                        descriptionController.text,
                        _datePicker,
                        widget.userModel.id!,
                      );
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                      // Xử lý sự kiện khi nhấn nút Add
                      // Đặt mã nguồn xử lý tại đây
                    },
                    child: const Text(
                      'Add Todo',
                      style: TextStyle(
                          //color: Color(0xFFF79E89),
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      // fixedSize:
                      //     Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
