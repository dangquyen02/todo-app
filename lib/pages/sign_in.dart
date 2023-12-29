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
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                      // height: 320.0,
                      // width: 410,
                      height: 300,
                      width: 300,
                      child: Image(
                        image: AssetImage('assets/images/sign_in.png'),
                        fit: BoxFit.cover,
                      )),
                  Container(
                    width: 327,
                    height: 48,
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Color(0x7F272727)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: 327,
                    height: 48,
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
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

                        // Lưu thông tin người dùng vào SharedPreferences
                        // await saveUserInfo(userNameController.text);

                        print('ok');
                        setState(() {
                          isLoading = false;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomePage(userModel: userModel),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        //backgroundColor: Colors.blueAccent,
                        backgroundColor: Colors.blue[600],
                        fixedSize: const Size(327, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('SIGN IN'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Căn giữa theo trục ngang
                    children: [
                      const Text(
                        "Don`t have an account?",
                        style: TextStyle(
                          color: Color(0x66272727),
                          fontSize: 14,
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
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Hàm để kiểm tra xem người dùng đã đăng nhập trước đó hay chưa
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('email');
    return userEmail != null && userEmail.isNotEmpty;
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
          title: const Text('Thông báo'),
          content: const Text('Email hoặc mật khẩu không đúng.'),
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

  void showPasswordErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Password'),
          content: const Text(
            'Mật khẩu phải có độ dài ít nhất 6 ký tự! '
            'Chứa ít nhất một chữ cái và không được chứa các ký tự đặc biệt.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
