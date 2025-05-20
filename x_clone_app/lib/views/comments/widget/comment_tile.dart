import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.post,
    required this.comment,
  });

  final Postmodel post;
  final Commentmodel comment;

  @override
  Widget build(BuildContext context) {
    void showOptions(BuildContext context,) {
    final String uid = comment.uid;
    final String currentUserId = AuthenticationRepository().getCurrentUid();
    final bool isownComment = uid == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isownComment)
                ListTile(
                  leading: Icon(Iconsax.trash, color: Colors.black),
                  title: Text('Delete Comment'),
                  onTap: () async {
                    await Provider.of<Userprovider>(context,listen: false).deleteCommets(comment.id,post.id);
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => ProfileScareen(post: post,uid: post.uid,));
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade400,
                    child: Center(
                      child: Icon(
                        Iconsax.profile_add,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ProfileScareen(post: post,uid: comment.uid,));
                  },
                  child: Text(
                    comment.name,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '@${comment.userName}',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(width: 10),
                Spacer(),
        
                // Text(post.timestamp),
                IconButton(
                  onPressed: () => {
                    showOptions(
                      context,
                      
                    ),
                  },
                  icon: (Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade800,
                  )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                comment.message,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}