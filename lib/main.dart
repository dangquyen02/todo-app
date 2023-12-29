import 'package:daily_planner/pages/add.dart';
import 'package:daily_planner/pages/change_password.dart';
import 'package:daily_planner/pages/chat_page.dart';
import 'package:daily_planner/pages/home_page.dart';
import 'package:daily_planner/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner/pages/sign_in.dart';
//import 'package:daily_planner/pages/add.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cbwspvlcfondanakbhvd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNid3NwdmxjZm9uZGFuYWtiaHZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE1ODQ3NTIsImV4cCI6MjAxNzE2MDc1Mn0.g7WK3gUjl0FIi6xIqUDsN7S_0vUPpeIUJvj3JLZvQjc',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      title: "Daily planner",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primaryColor: Color(0xFFF79E89),
        appBarTheme: AppBarTheme(
            elevation: 1,
            color: Colors.lightBlueAccent), //elevation: 1  khong thay shadow
      ),
    );
  }
}
