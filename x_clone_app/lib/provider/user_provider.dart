import 'package:flutter/foundation.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/model/user_model.dart';

class Userprovider with ChangeNotifier {
   UserModel? userModel;
  final _auth = AuthenticationRepository();
  final _db = UserRepository();
 bool _isLoaded = false;

  Future<UserModel?> loadUSerData(String uid)=>_db.getUserDetails(uid);

}
