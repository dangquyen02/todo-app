import 'package:daily_planner/pages/home_page.dart';
import 'package:daily_planner/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_planner/pages/sign_up.dart';
import '';

import '../model/user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final UserService _userService = UserService();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true; // hthi mật khẩu
  bool isLoading = false; // quay vòng quay vòng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                    height: 330.0,
                    width: 430,
                    child: Image(
                      //image: AssetImage('assets/images/Union.png'),
                      image: AssetImage('assets/images/f2.png'),
                      fit: BoxFit.cover,
                    )),
                Spacer(),
                Container(
                  width: 327,
                  height: 48,
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 327,
                  height: 48,
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0x7F272727)),
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
                SizedBox(height: 16.0),
                // Container(
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       // Xử lý đăng nhập
                //       setState(() {
                //         isLoading = true;
                //       });
                //       // Lưu thông tin người dùng vào SharedPreferences
                //       // saveUserInfo(emailController.text);
                //       UserModel? userModel = await _userService.getUser(
                //           userNameController.text, passwordController.text);
                //       if (userModel == null) {
                //         print('sai ten tk hoac mk hoac tk chua dki');
                //         setState(() {
                //           isLoading = false;
                //         });
                //         showIncorrectCredentialsDialog(context);
                //         return;
                //       }
                //       print('ok');
                //
                //       setState(() {
                //         isLoading = false;
                //       });
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) =>
                //                   HomePage(userModel: userModel)));
                //     },
                //     style: ElevatedButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       //backgroundColor: Color(0xfFF79E89),
                //       backgroundColor: Colors.blueAccent,
                //       fixedSize:
                //           Size(327, 48), // Đặt kích thước của nút (rộng x cao)
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //     ),
                //     child: isLoading
                //         ? CircularProgressIndicator(
                //             color: Colors.white,
                //           )
                //         : Text('SIGN IN'),
                //   ),
                // ),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Xử lý đăng nhập
                      setState(() {
                        isLoading = true;
                      });

                      // Kiểm tra độ dài và các yêu cầu khác của mật khẩu
                      String password = passwordController.text;
                      if (password.length < 6 ||
                          !password.contains(RegExp(r'[a-zA-Z]')) ||
                          password
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        setState(() {
                          isLoading = false;
                        });
                        showPasswordErrorDialog(context);
                        return;
                      }

                      // Tiếp tục xử lý đăng nhập
                      UserModel? userModel = await _userService.getUser(
                          userNameController.text, password);

                      if (userModel == null) {
                        print('sai ten tk hoac mk hoac tk chua dki');
                        setState(() {
                          isLoading = false;
                        });
                        showIncorrectCredentialsDialog(context);
                        return;
                      }

                      print('ok');
                      setState(() {
                        isLoading = false;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(userModel: userModel),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      fixedSize: Size(327, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text('SIGN IN'),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Căn giữa theo trục ngang
                  children: [
                    Text(
                      "Don`t have an account?",
                      style: TextStyle(
                        color: Color(0x66272727),
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignUpPage()), // Điều hướng sang trang đăng ký
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          //color: Color(0xFFF79E89),
                          color: Colors.blue[800],
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm để lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserInfo(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<void> showIncorrectCredentialsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Email hoặc mật khẩu không đúng.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void showPasswordErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Password'),
          content: Text(
            'Mật khẩu phải có độ dài ít nhất 6 ký tự! '
            'Chứa ít nhất một chữ cái và không được chứa các ký tự đặc biệt.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
