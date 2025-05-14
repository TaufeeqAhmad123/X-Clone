import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/components/textfield.dart';

import 'package:x_clone_app/provider/signup_provider.dart';
import 'package:x_clone_app/views/home.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 28, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Create Your Account',
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              // cursorColor: Colors.blue,
              controller: provider.nameController,
              labletext: 'First name',
              isPassord: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              // cursorColor: Colors.blue,
              controller: provider.seconNameController,
              labletext: 'second name',
              isPassord: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              // cursorColor: Colors.blue,
              controller: provider.emailController,
              labletext: 'Phone, email or @username',
              isPassord: false,
            ),
            SizedBox(height: 16),
            CustomTextField(
              // cursorColor: Colors.blue,
              controller: provider.passwordController,
              labletext: 'Password',
              isPassord: true,
            ),
            const SizedBox(height: 16),

            CupertinoButton(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 140,
                vertical: 10,
              ),
              borderRadius: BorderRadius.circular(20),

              child: Text(
                'Next',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
               provider.signup(context) ;
              
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                //  padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: Size(300, 40),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/google.png', height: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                // padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: Size(300, 40),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/apple.png', height: 20),
                  SizedBox(width: 10),
                  Text(
                    'Signup with apple',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
            SizedBox(height: 20),
            Text(
              "Don't have an account?",
              style: GoogleFonts.roboto(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),

              child: Text(
                'Login here',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TwitterLoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
