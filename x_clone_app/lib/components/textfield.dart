import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/provider/login_provider.dart';

class CustomTextField extends StatelessWidget {
  final Icon? icon;
  final TextEditingController controller;
  final String labletext;
  final String? Function(String?)? validator;
  bool isPassord;

  CustomTextField({
    super.key,
    required this.controller,
    required this.labletext,
    this.isPassord = false,
    this.icon, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return TextFormField(
      cursorColor: Colors.blue,
      controller: controller,
      validator: validator,
      style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
      obscureText: isPassord ? !provider.isVisible : false,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        labelText: labletext,

        suffixIcon: isPassord
            ? IconButton(
                icon: Icon(
                  provider.isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  provider.toggleVisibility();
                },
              )
            : null,
        floatingLabelStyle: GoogleFonts.roboto(color: Colors.blue),
        labelStyle: GoogleFonts.roboto(color: Colors.grey),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
