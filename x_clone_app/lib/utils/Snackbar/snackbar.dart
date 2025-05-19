import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SnackbarUtil  {
 static successSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.blue,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Iconsax.check, color: Colors.white),
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
    );
  }
}

