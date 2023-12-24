import 'package:daily_planner/model/user_model.dart';
import 'package:daily_planner/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListFriendpage extends StatefulWidget {
  const ListFriendpage({super.key, required this.idUser});
  final int idUser;
  @override
  State<ListFriendpage> createState() => _ListFriendpageState();
}

class _ListFriendpageState extends State<ListFriendpage> {
  final _supabase = Supabase.instance.client;
  late final Stream<List<UserModel>> _userModelStream;
  @override
  void initState() {
    // TODO: implement initState
    _userModelStream = _supabase
        .from("user")
        .stream(primaryKey: ['id'])
        .order("id", ascending: true)
        .map((maps) {
          return maps.map((map) {
            return UserModel.fromJson(map);
          }).toList();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text('danh sach')),
          Expanded(
              child: StreamBuilder<List<UserModel>>(
                  stream: _userModelStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data!.length);
                      List<UserModel> listUserModel = [];
                      for (var item in snapshot.data!) {
                        if (item.id != widget.idUser) {
                          listUserModel.add(item);
                        }
                      }
                      return ListView.builder(
                          itemCount: listUserModel.length,
                          itemBuilder: (context, index) => Card(
                                color: Colors
                                    .greenAccent, // Màu nền của từng công việc: const Color(0xFFF79E89)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(listUserModel[index].name!),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          idUser: widget.idUser,
                                          userRecive: listUserModel[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ));
                    }
                    return Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }))
        ],
      ),
    ));
  }
}
