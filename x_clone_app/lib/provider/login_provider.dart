import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/utils/loading_dialog.dart';
import 'package:x_clone_app/utils/snackbar.dart';
import 'package:x_clone_app/views/authGate.dart';

import '../views/home.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isVisible = false;
  bool get isVisible => _isVisible;
  bool get isLoading => _isLoading;
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

      await _authenticationRepository.Login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      notifyListeners();

      SnackbarUtil.showSuccess(context, 'Signup successful');
      Get.offAll(() => Authgate());
    } catch (e) {
      print(e);
      _isLoading = false;
      hideLoading();
      notifyListeners();

      SnackbarUtil.showError(context, 'Login failed: ${e.toString()}');
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
