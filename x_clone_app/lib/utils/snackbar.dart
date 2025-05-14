import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackbarUtil  {
 static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, Colors.red);
  }
  
 static void _show(BuildContext context,String message,Color color){
    final snackbar=SnackBar(
       content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}