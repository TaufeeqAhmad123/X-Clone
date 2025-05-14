import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/utils/loading_dialog.dart';
import 'package:x_clone_app/utils/snackbar.dart';
import 'package:x_clone_app/views/authGate.dart';

class SignupProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController seconNameController = TextEditingController();

  bool _isLoading = false;
  bool _isVisible = false;
  bool get isVisible => _isVisible;
  bool get isLoading => _isLoading;
  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
      final UserRepository _userRepository = UserRepository();
  User? _user;
  User? get user => _user;
  Future<void> signup(BuildContext context) async {
    try {
      _isLoading = true;
      showLoding();
      notifyListeners();

      final user = await _authenticationRepository.Signup(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    
       _userRepository.addUser(
        nameController.text.trim(),
        seconNameController.text.trim(),
        emailController.text.trim(),
        );
      notifyListeners();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtil.showSuccess(context, 'Signup successful');
        Get.offAll(() => const Authgate());
        hideLoading();
      });
    } catch (e) {
      print(e);
      _isLoading = false;
      hideLoading();
      notifyListeners();

      SnackbarUtil.showError(context, 'Login failed: ${e.toString()}');
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    seconNameController.clear();
    notifyListeners();
  }
}
