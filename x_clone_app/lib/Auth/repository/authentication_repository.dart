import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/views/home.dart';

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
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted.');
      } else {
        print('Error: ${e.message}');
      }
      rethrow;
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted.');
      } else {
        print('Error: ${e.message}');
      }
      rethrow;
    } catch (e) {
      print(e);
      throw Exception('An unknown error occurred during signup.');
    }
  }

  Future<void> Logout() async {
    await _auth.signOut();
  }




  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  Stream<User?> get authstatechange {
    return _auth.authStateChanges();
  }
}
