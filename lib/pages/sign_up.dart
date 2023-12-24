import 'package:daily_planner/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_planner/pages/sing_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserService _userService = UserService();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign Up'),
      // ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const SizedBox(
                    height: 250.0,
                    width: 250,
                    child: Image(
                      //image: AssetImage('assets/images/Union.png'),
                      image: AssetImage('assets/images/f01.png'),
                      fit: BoxFit.cover,
                    )),
                const Spacer(),
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
                    controller: fullnameController,
                    decoration: InputDecoration(
                      labelText: 'Fullname',
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
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 327,
                  height: 48,
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x7F272727)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: () {
                //     print('tap');
                //     // Xử lý đăng ky
                //     _userService.createUser(userNameController.text,
                //         passwordController.text, fullnameController.text);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     //primary: const Color(0xFFF79E89),
                //     backgroundColor: Colors.blueAccent,
                //     fixedSize: const Size(
                //         327, 48), // Đặt kích thước của nút (rộng x cao)
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12.0),
                //     ),
                //   ),
                //   child: const Text('SIGN UP'),
                // ),
                ElevatedButton(
                  onPressed: () {
                    print('tap');
                    // Xử lý đăng ký

                    // Kiểm tra độ dài và các yêu cầu khác của mật khẩu
                    String password = passwordController.text;
                    if (password.length < 6 ||
                        !password.contains(RegExp(r'[a-zA-Z]')) ||
                        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      showPasswordErrorDialog(context);
                      return;
                    }

                    // Kiểm tra tên đăng nhập phải có đuôi @gmail.com
                    String username = userNameController.text;
                    if (!username.endsWith('@gmail.com')) {
                      showInvalidUsernameDialog(context);
                      return;
                    }

                    _userService.createUser(
                      username,
                      password,
                      fullnameController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: const Size(327, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('SIGN UP'),
                ),

                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Căn giữa theo trục ngang
                  children: [
                    const Text(
                      "Already have an account? ",
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
                                  SignInPage()), // Điều hướng sang trang đăng nhập
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.blue,
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
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
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

  void showInvalidUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Username'),
          content: Text('Tên người dùng phải kết thúc bằng @gmail.com.'),
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
