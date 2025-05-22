import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoding() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(

        child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
      ),
    ),
  );
}

void hideLoading() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}