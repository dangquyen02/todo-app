import 'package:daily_planner/model/message_modell.dart';
import 'package:daily_planner/service/message_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.idUser, required this.userRecive});
  final UserModel userRecive;
  final int idUser;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _supabase = Supabase.instance.client;
  late final Stream<List<MessageModel>> _messageStream;
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _messageStream = _supabase
        .from("message")
        .stream(primaryKey: ['id'])
        .order("create_at", ascending: false)
        .map((maps) {
          return maps.map((map) {
            return MessageModel.fromJson(map);
          }).toList();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Text(
                  widget.userRecive.name!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  width: 50,
                  height: 50,
                )
              ],
            ),
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                  stream: _messageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      List<MessageModel> listMessage = [];
                      for (var item in snapshot.data!) {
                        if ((item.idRecive == widget.idUser &&
                                item.idSend == widget.userRecive.id) ||
                            (item.idRecive == widget.userRecive.id &&
                                item.idSend == widget.idUser)) {
                          listMessage.add(item);
                        }
                        print(listMessage.length);
                      }
                      return ListView.builder(
                          reverse: true,
                          itemCount: listMessage.length,
                          itemBuilder: (context, index) => Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: listMessage[index]
                                              .idSend ==
                                          widget.idUser
                                      ? CrossAxisAlignment
                                          .end // căn chỉnh message theo cạnh phải (gửi đi)
                                      : CrossAxisAlignment
                                          .start, // căn chỉnh message theo cạnh trái (nhận)
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 4),
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.7,
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                      ),
                                      decoration: BoxDecoration(
                                          color: listMessage[index].idSend ==
                                                  widget.idUser
                                              ? Colors.blue[300]
                                              : Colors.yellow[400],
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text(listMessage[index].message),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                  ],
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
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 6),
                  Icon(Icons.camera_alt),
                  SizedBox(width: 6),
                  Icon(Icons.image),
                  SizedBox(width: 6),
                  Icon(Icons.mic),
                  SizedBox(width: 6),
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        fillColor: Colors.deepPurple,
                        hoverColor: Colors.deepPurple,
                        focusColor: Colors.deepPurple,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22)),
                        hintText: 'Nhập nội dung',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        _messageService.createMessage(_messageController.text,
                            widget.idUser, widget.userRecive.id!);
                        _messageController.clear();
                      },
                      child: Icon(Icons.send))
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ));
  }
}
