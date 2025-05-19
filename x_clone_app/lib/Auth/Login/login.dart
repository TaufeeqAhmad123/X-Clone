import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/SignUp/signup.dart';
import 'package:x_clone_app/components/textfield.dart';
import 'package:x_clone_app/provider/login_provider.dart';
import 'package:x_clone_app/utils/validator/validator.dart';

class TwitterLoginPage extends StatelessWidget {
  const TwitterLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
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
              'To get started, first enter your phone, email address or @username',
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: provider.loginformKey,
              child: Column(children: [
              CustomTextField(
                validator:(value)=> TValidator.validateEmail(value),
              // cursorColor: Colors.blue,
              controller: provider.emailController,
              labletext: 'Phone, email or @username',
              isPassord: false,
            ),
            SizedBox(height: 16),
            CustomTextField(
              // cursorColor: Colors.blue,
              
               validator: (value) => TValidator.validatePassword(value),
              controller: provider.passwordController,
              labletext: 'Password',
              isPassord: true,
            ),
            ],)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.roboto(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              borderRadius: BorderRadius.circular(20),
          
              child: Text(
                'Next',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: ()=>provider.login(context),
            ),
            const SizedBox(height: 16),
            Text(
              "Don't have an account?",
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
             
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 1,
                ),
              ),
            
              child: Text(
                'Signup here',
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
                    builder: (context) => const SignupScreen(),
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
