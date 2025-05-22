import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/utils/Exception/firebase_auth_exception.dart';
import 'package:x_clone_app/utils/Exception/firebase_exception.dart';
import 'package:x_clone_app/utils/Exception/formate_exception.dart';
import 'package:x_clone_app/utils/Exception/platfrom_exception.dart';
import 'package:x_clone_app/views/home/home.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // AuthenticationRepository() {
  //   screenRedirect();
  // }
  void screenRedirect() {
    final user = _auth.currentUser;
    if (user != null) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => const TwitterLoginPage());
    }
  }

  Future<UserCredential> Signup(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e);
      throw Exception('An unknown error occurred during signup.');
    }
  }

  Future<UserCredential> Login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    }on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    }catch (e) {
      print(e);
      throw Exception('An unknown error occurred during signup.');
    }
  }

  Future<void> Logout() async {
    try{
      await  _auth.signOut();
    }on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    }catch (e) {
      print(e);
      throw Exception('An unknown error occurred during signup.');
    }
  }
Future<void> deleteUserAccount() async {
    final user=_auth.currentUser;
   
    try {
      if(user != null) {
await UserRepository().deleteuserDetail(user.uid);
        await user.delete();

      }
      
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
      throw 'Something went wrong. Please try again';
    }
  }



  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  Stream<User?> get authstatechange {
    return _auth.authStateChanges();
  }
}
