import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/views/setting/blockUser_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 15,
          children: [
            _actionwidget('Block user', () {
              Get.to(() => blockeduserScreen());
            }),
            
            _actionwidget('Delete account', ()async {
              await AuthenticationRepository().deleteUserAccount();
              Get.snackbar('Account Deleted', 'Your account has been deleted successfully');
              Get.offAll(() => TwitterLoginPage());

            }),
            _actionwidget('Update Profile', () {
              Get.to(() => blockeduserScreen());
            }),
          ],
        ),
      ),
    );
  }

  Container _actionwidget(String title,void Function()? onPressed) {
    return Container(
            height: 80,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                IconButton(
                  onPressed:onPressed,
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          );
  }
}
