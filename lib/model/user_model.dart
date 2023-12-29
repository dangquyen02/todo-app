class UserModel {
  int? id;
  String? userName;
  String? passWord;
  String? name;

  //hàm tạo
  UserModel({this.id, this.userName, this.passWord, this.name});

  //Tạo ra đối tượng UseModel từ 1 Map<String, dynamic>. Chuyển đổi dữ liệu từ dạn Json sang đối tượng dart (lấy dữ liệu về)
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      userName: json['user_name'],
      passWord: json['pass_word'],
      name: json['name']);

  //... chuyển đổi thành Json (gửi  dữ liệu lên)
  Map<String, dynamic> toJson() {
    return {'user_name': userName, 'pass_word': passWord, 'name': name};
  }
}
