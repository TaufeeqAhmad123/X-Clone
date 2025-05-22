import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/utils/dialoag/loading_dialog.dart';
import 'package:x_clone_app/utils/Snackbar/snackbar.dart';
import 'package:x_clone_app/views/authGate.dart';

import '../views/home/home.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isVisible = false;
  bool get isVisible => _isVisible;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  User? _user;
  User? get user => _user;
  Future<void> login(BuildContext context) async {
    try {
      _isLoading = true;
      showLoding();

      notifyListeners();
      if(!loginformKey.currentState!.validate()){
        hideLoading();
        _isLoading = false;
        return;
      }

      await _authenticationRepository.Login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      notifyListeners();

      SnackbarUtil.successSnackBar(
        title: 'Success',
        message: 'Login successful',
      );
      Get.offAll(() => Authgate());
    } catch (e) {
      print(e);
      _isLoading = false;
      hideLoading();
      notifyListeners();

      SnackbarUtil.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  set isLoading(bool value) {
    _isLoading = value;
    hideLoading();
    notifyListeners();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
