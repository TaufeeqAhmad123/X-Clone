import 'package:flutter/material.dart';

class AppDialog{
   void showConfirmationDialod(String title,subtitle,confirmtext,cancelText,context,Function() onConfirm,Function() onCancel){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: onConfirm,
                child: Text(confirmtext),
              ),
              TextButton(
                onPressed:onCancel,
                child: Text(cancelText),
              ),
            ],
          );
        },
      );
    }
}