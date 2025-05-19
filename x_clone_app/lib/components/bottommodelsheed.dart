import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/model/postModel.dart';

class bottomSheet {
  void showOptions(BuildContext context, Postmodel post, provider) {
    final String uid = post.uid;
    final String currentUserId = AuthenticationRepository().getCurrentUid();
    final bool isCurrentUser = uid == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isCurrentUser)
                ListTile(
                  leading: Icon(Iconsax.trash, color: Colors.black),
                  title: Text('Delete Post'),
                  onTap: () async {
                    await provider.deletepost(post.id);
                    // await AuthenticationRepository().deletepost(widget.post.uid);
                    Navigator.pop(context);
                  },
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.flag, color: Colors.black),
                  title: Text('Report'),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block, color: Colors.black),
                  title: Text('Block User'),
                  onTap: () async {
                    // await AuthenticationRepository().deletepost(widget.post.uid);
                    Navigator.pop(context);
                  },
                ),
              ],
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.black),
                title: Text('Edit Post'),
                onTap: () {
                  // Handle edit post action
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showPostDialog(
    final  controller,
    void Function()? onPressed,
  ) {
   //  final  postController = TextEditingController();

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
                    controller: controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if(
                    controller.text.isNotEmpty){
                    onPressed!();
                    Get.back();
                  }else{
                    Get.snackbar("Error", "Please enter a message",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                child: Text(
                  "Post",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
