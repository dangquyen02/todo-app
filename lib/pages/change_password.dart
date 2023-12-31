import 'package:daily_planner/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner/service/user_service.dart';
import 'package:daily_planner/pages/home_page.dart';
import '../model/user_model.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.userModel});
  final UserModel userModel;
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final UserService _userService = UserService();
  final TextEditingController oldPassworkController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconButton(
                //     onPressed: () => Navigator.pop(context),
                //     icon: const Icon(
                //       Icons.arrow_back,
                //       size: 24,
                //     )),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(36)),
                      child: Icon(Icons.navigate_before)),
                ),

                Container(
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 300.0,
                    width: 300.0,
                    child: Image(
                      image: AssetImage('assets/images/change.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 30,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    "Name: " + widget.userModel.name.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 2.0),
                Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    "User name: " + widget.userModel.userName.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 48,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: TextField(
                    controller: oldPassworkController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Old password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 48,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: TextField(
                    controller: newPasswordController,
                    obscureText: _obscureText2,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Xử lý đăng nhập
                      setState(() {});

                      UserModel? userModel = await _userService.getUser(
                          widget.userModel.userName.toString(),
                          oldPassworkController.text);
                      if (userModel == null) {
                        print('sai');
                        setState(() {});
                        showIncorrectCredentialsDialog(
                            context, "Mật khẩu không đúng");
                        return;
                      } else if (newPasswordController.text == "") {
                        showIncorrectCredentialsDialog(
                            context, "Nhập mật khẩu mới");
                        return;
                      } else if (newPasswordController.text.length < 6) {
                        showIncorrectCredentialsDialog(
                            context, "Mật khẩu mới từ 6 kí tự");
                        return;
                      } else if (oldPassworkController.text !=
                          widget.userModel.passWord) {
                        showIncorrectCredentialsDialog(
                            context, "Mật khẩu không đúng");
                        return;
                      } else if (oldPassworkController == "") {
                        showIncorrectCredentialsDialog(
                            context, "Nhập mật khẩu");
                        return;
                      }
                      print('ok');

                      UserModel? userM = await _userService.updateUser(
                          widget.userModel, newPasswordController.text);

                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(userModel: userModel)));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent, //Color(0xFFF79E89)
                      fixedSize: Size(MediaQuery.of(context).size.width, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text('CHANGE PASSWORD'),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
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
          title: const Text('Thông báo'),
          content: Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
