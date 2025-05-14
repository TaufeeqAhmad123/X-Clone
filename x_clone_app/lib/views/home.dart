import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/components/my_drawer.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/utils/dialoag.dart';
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
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          
        ),
        onPressed: () {
          showPostDialog();
        },
        child: Icon(Icons.add),
      ),
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
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(radius: 20),

                    Text('Taufeeq Ahmad'),
                    Text('@Taufeeq Ahmad'),

                    Icon(Icons.settings, color: Colors.black),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    'This is my bio a book or other written or printed work, regarded in terms of its content rather than its physical form. the main body of a book or other piece of writing, as distinct from other material such as notes, appendices, and illustrations.',
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    actionRow(icon: (Icons.heart_broken),count: '9',),
                    actionRow(icon: (Icons.report_sharp),count: '32',),
                    actionRow(icon: (Icons.comment),count: '3232',),
                    actionRow(icon: (Icons.analytics),count: '9',),
                    actionRow(icon: (Icons.bookmark),count: '',),
                   
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class actionRow extends StatelessWidget {
  final String count;
  final IconData icon;
  const actionRow({
    super.key,required this.count, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700,),
        SizedBox(width: 6,),
        Text(count,style: GoogleFonts.roboto(),)
      ],
    );
  }
}
