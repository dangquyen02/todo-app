import 'package:daily_planner/model/todo_model.dart';
import 'package:daily_planner/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.todoModel, required this.userModel});
  final UserModel userModel;
  final TodoModel todoModel;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // chọn ảnh từ thư viện

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imagePathController.text = pickedFile.path;
  //     });
  //   }
  // }

  // chọn ngày, giờ từ lịch
  TextEditingController _dateTimeController = TextEditingController();

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
          color: Colors.blue[800],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                // Ô nhập title
                Container(
                  height: 48,
                  child: TextField(
                    style: TextStyle(
                        color: Colors.white), // Chữ nhập vào màu trắng
                    decoration: InputDecoration(
                      labelText: 'Edit title',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Ô nhập nội dung
                Container(
                  height: 350,
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Edit description',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 48,
                  child: TextField(
                    readOnly: true,
                    controller: _dateTimeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Select Date and Time',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
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
                SizedBox(height: 20),

                // Nút Add
                ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút Add
                    // Đặt mã nguồn xử lý tại đây
                  },
                  child: Text(
                    'EDIT TODO',
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize:
                        Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
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
