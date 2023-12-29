import 'dart:async';

import 'package:daily_planner/model/todo_model.dart';
import 'package:daily_planner/model/user_model.dart';
import 'package:daily_planner/pages/change_password.dart';
import 'package:daily_planner/pages/list_friend_page.dart';
import 'package:daily_planner/pages/sign_in.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // List<ToDoItem> toDoItems = [];
  final TextEditingController _searchController =
      TextEditingController(text: '');
  late final Stream<List<TodoModel>> _todoStream;
  final _supabase = Supabase.instance.client;
  Timer? _debounce;
  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _todoStream = _supabase
        .from("todo")
        .stream(primaryKey: ['id'])
        .order("id", ascending: true)
        .map((maps) {
          return maps.map((map) {
            return TodoModel.fromJson(map);
          }).toList();
        });
    init();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  init() async {
    List<dynamic> asd = await _supabase.from("todo").select();
    print(TodoModel.fromJson(asd[0]));
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _onSearchChanged() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      print('tien');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey,
        child: Scaffold(
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
            backgroundColor: Colors.deepPurple,
          ),
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Daily Planner",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontSize: 15),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListFriendpage(
                                        idUser: widget.userModel.id!,
                                      )));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        //color: const Color(0xFFF79E89),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                      ),
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
                  ),

                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const SizedBox(
                              height: 35.0,
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
                          Spacer(),

                          // tìm kiếm
                          Container(
                            width: 200,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 0),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    fillColor: Colors.deepPurple,
                                    hoverColor: Colors.deepPurple,
                                    focusColor: Colors.deepPurple,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    hintText: 'Nhập tiêu đề',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //const Spacer(),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            tooltip: '',
                            icon: const Icon(Icons.filter_alt_outlined),
                            //color: const Color(0xFFF79E89),
                            color: Colors.deepPurple,
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút
                              // Đặt mã nguồn xử lý tại đây
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Tìm kiếm
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 4, right: 4),
                  //   child: TextFormField(
                  //     controller: _searchController,
                  //     decoration: InputDecoration(
                  //       fillColor: Colors.deepPurple,
                  //       hoverColor: Colors.deepPurple,
                  //       focusColor: Colors.deepPurple,
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(16)),
                  //       hintText: 'Nhập tiêu đề',
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  Material(
                    color: Colors.deepPurple,
                    child: TabBar(
                      controller: _tabController,
                      unselectedLabelColor: Color.fromARGB(255, 2, 206, 16),
                      indicatorColor: Colors.white,
                      indicatorPadding: EdgeInsets.only(bottom: 2),
                      tabs: const <Widget>[
                        Tab(
                          child: Text(
                            'Tất cả',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Đang làm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Đã làm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //list todo
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        StreamBuilder<List<TodoModel>>(
                            stream: _todoStream,
                            builder: (context, snapshot) {
                              print(snapshot.data);
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                List<TodoModel> todos =
                                    snapshot.data as List<TodoModel>;
                                List<TodoModel> todosResult = [];
                                if (_searchController.text.isEmpty) {
                                  for (var item in todos) {
                                    if (item.userId == widget.userModel.id)
                                      todosResult.add(item);
                                  }
                                } else {
                                  for (var item in todos) {
                                    if (item.userId == widget.userModel.id &&
                                        item.title!
                                            .contains(_searchController.text)) {
                                      todosResult.add(item);
                                    }
                                  }
                                }

                                return ListView.builder(
                                  itemCount: todosResult.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: todosResult[index].check!
                                          ? Colors.greenAccent
                                          : Colors.yellow[400],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(todosResult[index].title!),
                                        subtitle: Text(DateFormat(
                                                'dd/MM/yyyy, HH:mm')
                                            .format(todosResult[index].time!)),
                                        trailing: todosResult[index].check!
                                            ? Icon(Icons.check)
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
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
                            }),

                        // công việc chưa làm
                        StreamBuilder<List<TodoModel>>(
                            stream: _todoStream,
                            builder: (context, snapshot) {
                              print(snapshot.data);
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                List<TodoModel> todos =
                                    snapshot.data as List<TodoModel>;
                                List<TodoModel> todosResult = [];
                                if (_searchController.text.isEmpty) {
                                  for (var item in todos) {
                                    if (item.userId == widget.userModel.id &&
                                        item.check! == false)
                                      todosResult.add(item);
                                  }
                                } else {
                                  for (var item in todos) {
                                    if (item.userId == widget.userModel.id &&
                                        item.check! == false &&
                                        item.title!
                                            .contains(_searchController.text)) {
                                      todosResult.add(item);
                                    }
                                  }
                                }

                                return ListView.builder(
                                  itemCount: todosResult.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.yellow[
                                          400], // Màu nền của từng công việc: const Color(0xFFF79E89)
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(todosResult[index].title!),
                                        subtitle: Text(DateFormat(
                                                'dd/MM/yyyy, HH:mm')
                                            .format(todosResult[index].time!)),
                                        trailing: todosResult[index].check!
                                            ? Icon(Icons.check)
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
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
                              return Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }),

                        // công việc đã hoàn thành
                        StreamBuilder<List<TodoModel>>(
                            stream: _todoStream,
                            builder: (context, snapshot) {
                              print(snapshot.data);
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                List<TodoModel> todos =
                                    snapshot.data as List<TodoModel>;
                                List<TodoModel> todosResult = [];
                                if (_searchController.text.isEmpty) {
                                  for (var item in todos) {
                                    if (item.userId == widget.userModel.id &&
                                        item.check! == true)
                                      todosResult.add(item);
                                  }
                                } else {
                                  for (var item in todos) {
                                    if (item.userId == widget.userModel.id &&
                                        item.check! == true &&
                                        item.title!
                                            .contains(_searchController.text)) {
                                      todosResult.add(item);
                                    }
                                  }
                                }

                                return ListView.builder(
                                  itemCount: todosResult.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.greenAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(todosResult[index].title!),
                                        subtitle: Text(DateFormat(
                                                'dd/MM/yyyy, HH:mm')
                                            .format(todosResult[index].time!)),
                                        trailing: todosResult[index].check!
                                            ? Icon(Icons.check)
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
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
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
