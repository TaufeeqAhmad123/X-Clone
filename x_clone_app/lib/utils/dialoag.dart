import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void showPostDialog() {
  final TextEditingController postController = TextEditingController();
  File? selectedImage;

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text("Create Post"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: postController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedImage != null)
                  Image.file(
                    selectedImage!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    // final picker = ImagePicker();
                    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    // if (pickedFile != null) {
                    //   setState(() {
                    //     selectedImage = File(pickedFile.path);
                    //   });
                    // }
                  },
                  icon: Icon(Icons.photo),
                  label: Text("Pick from Gallery"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = postController.text.trim();
                if (text.isNotEmpty || selectedImage != null) {
                  // Handle post logic here (e.g., upload to Firebase)
                  print("Post: $text");
                  if (selectedImage != null) {
                    print("Image path: ${selectedImage!.path}");
                  }
                  Get.back(); // Close dialog
                } else {
                  Get.snackbar("Empty Post", "Please write something or pick an image");
                }
              },
              child: Text("Post"),
            ),
          ],
        );
      },
    ),
  );
}
