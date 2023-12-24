class MessageModel {
  int? id;
  int? idSend;
  int? idRecive;
  String message;
  DateTime? createAt;
  MessageModel(
      {this.id,
      this.idSend,
      this.idRecive,
      required this.message,
      this.createAt});
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'],
      message: json['message'],
      idSend: json['id_send'],
      idRecive: json['id_receive'],
      createAt: DateTime.parse(json['create_at']));

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'id_send': idSend,
      'id_receive': idRecive,
      'create_at': DateTime.now().toIso8601String()
    };
  }
}
