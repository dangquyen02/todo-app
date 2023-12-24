class UserModel {
  int? id;
  String? userName;
  String? passWord;
  String? name;

  UserModel({this.id, this.userName, this.passWord, this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      userName: json['user_name'],
      passWord: json['pass_word'],
      name: json['name']);

  Map<String, dynamic> toJson() {
    return {'user_name': userName, 'pass_word': passWord, 'name': name};
  }
}
