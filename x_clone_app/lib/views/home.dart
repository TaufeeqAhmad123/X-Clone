import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/components/my_drawer.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  @override
   FirebaseAuth auth = FirebaseAuth.instance;
   void logout() async {
    try {
      await auth.signOut();
      print('User logged out successfully');
    } catch (e) {
      print('Error logging out: $e');
    }}
   
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TwitterLoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    
      drawer: MyDrawer(),
      body: Center(child: TextButton(onPressed: ()=>Get.off(()=>ProfileScareen()), child: Text('profile')),),
      
    );
  }
}