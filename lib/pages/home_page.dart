import 'package:daily_planner/model/todo_model.dart';
import 'package:daily_planner/model/user_model.dart';
import 'package:daily_planner/pages/change_password.dart';
import 'package:daily_planner/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner/pages/add.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userModel});
  final UserModel userModel;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<ToDoItem> toDoItems = [];
  late final Stream<List<TodoModel>> _todoStream;
  final _supabase = Supabase.instance.client;
  @override
  void initState() {
    // TODO: implement initState
    _todoStream = _supabase.from("todo").stream(primaryKey: ['id'])
        // .order("id")
        .map((maps) {
      return maps.map((map) {
        return TodoModel.fromJson(map);
      }).toList();
    });
    init();
    super.initState();
  }

  init() async {
    List<dynamic> asd = await _supabase.from("todo").select();
    print(TodoModel.fromJson(asd[0]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPage(
                      userModel: widget.userModel,
                    )),
          );
        },
        tooltip: 'Thêm công việc',
        child: const Icon(Icons.add),
        backgroundColor:
            Colors.deepPurple, // Màu của nút thêm công việc Color(0xFFF76C6A)
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "TO DO LIST",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //color: Color(0xFFF79E89),
                          color: Colors.deepPurple,
                          fontSize: 15),
                    ),
                  ),
                  const Spacer(),
                  // Điều chỉnh khoảng cách từ phải sang trái
                  IconButton(
                    tooltip: 'Cài đặt',
                    icon: const Icon(Icons.settings),
                    //color: const Color(0xFFF79E89),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword(
                                    userModel: widget.userModel,
                                  )));
                    },
                  ),
                ],
              ), // Khoảng cách giữa hai Row
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 35.0, //17
                          width: 35.0,
                          child: Image(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "LIST OF TO DO",
                        style: TextStyle(
                          color: Colors.deepPurple, //(0xFFF76C6A)
                          fontFamily: 'Bebas Neue',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          //height: 0,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: '',
                        icon: const Icon(Icons.filter_alt_outlined),
                        //color: const Color(0xFFF79E89),
                        color: Colors.blueAccent,
                        onPressed: () {
                          // Xử lý sự kiện khi nhấn nút
                          // Đặt mã nguồn xử lý tại đây
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: StreamBuilder<List<TodoModel>>(
                      stream: _todoStream,
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          List<TodoModel> todos =
                              snapshot.data as List<TodoModel>;
                          List<TodoModel> todosResult = [];
                          for (var item in todos) {
                            if (item.userId == widget.userModel.id)
                              todosResult.add(item);
                          }
                          return ListView.builder(
                            itemCount: todosResult.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.lightBlue[
                                    100], // Màu nền của từng công việc: const Color(0xFFF79E89)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(todosResult[index].title!),
                                  subtitle: Text(DateFormat('dd/MM/yyyy, HH:mm')
                                      .format(todosResult[index].time!)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            userModel: widget.userModel,
                                            todo: todosResult[index]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                        print('aaaa');
                        return Container();
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

// class DetailPage extends StatelessWidget {
//   final TodoModel toDoItem;
//
//   DetailPage(this.toDoItem);
//
//
//   }
// }
