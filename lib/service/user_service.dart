import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_model.dart';

class UserService {
  final _supabase = Supabase.instance.client;
  Future<UserModel?> createUser(
      String userName, String passWord, String name) async {
    List<dynamic> createUser = await _supabase
        .from('user')
        .insert(UserModel(userName: userName, passWord: passWord, name: name)
            .toJson())
        .select();
    if (createUser.isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(createUser[0]);
    }
    // return null;
  }

  Future<UserModel?> getUser(String userName, String passWord) async {
    List<dynamic> getUsr = await _supabase
        .from('user')
        .select()
        .eq('user_name', userName)
        .eq('pass_word', passWord);
    if (getUsr.isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(getUsr[0]);
    }
    // return null;
  }

  Future<List<UserModel>> getAllUser() async {
    List<UserModel> listUserModel = [];
    List<dynamic> getUsr = await _supabase.from('user').select();
    if (getUsr.isEmpty) {
      return [];
    } else {
      for (var item in getUsr) {
        listUserModel.add(UserModel.fromJson(item));
      }
      return listUserModel;
    }
    // return null;
  }

  Future<UserModel?> updateUser(UserModel userModel, String newpass) async {
    userModel.passWord = newpass;
    List<dynamic> createUser = await _supabase
        .from('user')
        .update(userModel.toJson())
        .eq("id", userModel.id)
        .select();
    if (createUser.isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(createUser[0]);
    }
    // return null;
  }
}
