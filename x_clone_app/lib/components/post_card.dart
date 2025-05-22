import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/components/bottommodelsheed.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/utils/Snackbar/snackbar.dart';
import 'package:x_clone_app/utils/dialoag/confirmation_dialog.dart';
import 'package:x_clone_app/views/comments/comments_screen.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class postCard extends StatefulWidget {
  final Postmodel post;
  const postCard({super.key, required this.post});

  //final Userprovider provider;

  @override
  State<postCard> createState() => _postCardState();
}

class _postCardState extends State<postCard> {
  late final provider = Provider.of<Userprovider>(context);
  late final databaseProvider = Provider.of<Userprovider>(
    context,
    listen: false,
  );
  @override
  initState() {
    super.initState();
    _loadcomments();
  }

  Future<void> _loadcomments() async {
    await databaseProvider.loadcomments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    void _showOptions() {
      final String uid = widget.post.uid;
      final String currentUserId = AuthenticationRepository().getCurrentUid();

      final bool isCurrentUser = uid == currentUserId;
      print('post id${widget.post.id}');
    
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
                      await databaseProvider.deletepost(widget.post.id);
                      // await AuthenticationRepository().deletepost(widget.post.uid);
                      Navigator.pop(context);
                    },
                  )
                else ...[
                  ListTile(
                    leading: Icon(Icons.flag, color: Colors.black),
                    title: Text('Report'),
                    onTap: () => AppDialog().showConfirmationDialod(
                      'Report Post',
                      'Are you sure to report the post',

                      'Report ',
                      'cancel',
                      context,
                      () async {
                        await databaseProvider.reportUser(
                          widget.post.uid,
                          widget.post.id,
                        );
                        SnackbarUtil.successSnackBar(
                          title: 'Success',
                          message: 'Post reported successfully',
                        );
                        Navigator.pop(context);
                      },
                      () => Navigator.pop(context),
                    ),

                    //  Navigator.pop(context);
                  ),
                  ListTile(
                    leading: Icon(Icons.block, color: Colors.black),
                    title: Text('Block User'),
                     onTap: () => AppDialog().showConfirmationDialod(
                      'Block User',
                      'Are you sure to Block the Uaer',

                      'Unblock ',
                      'cancel',
                      context,
                      () async {
                        await databaseProvider.blockUserinFirebase(widget.post.uid);
                        SnackbarUtil.successSnackBar(
                          title: 'Success',
                          message: 'User Block successfully',
                        );
                        Navigator.pop(context);
                      },
                      () => Navigator.pop(context),
                    ),
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

    void toggleLike() async {
      await databaseProvider.likePost(widget.post.id);
    }

    late final provider = Provider.of<Userprovider>(context);
    bool isCurrentUser = provider.isCurrentsUserLikePost(widget.post.id);
    int comments = databaseProvider.getComments(widget.post.id).length;
    print('comments length $comments');
    final TextEditingController controller = TextEditingController();
    return Card(
      child: GestureDetector(
        onTap: () {
          // Handle post tap
          Get.to(() => CommentsScreen(post: widget.post));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ProfileScareen(
                          post: widget.post,
                          uid: widget.post.uid,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade400,
                      child: Center(
                        child: Icon(Iconsax.profile_add, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(
                      () => ProfileScareen(
                        post: widget.post,
                        uid: widget.post.uid,
                      ),
                    ),
                    child: Text(
                      widget.post.name,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '@${widget.post.userName}',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(width: 10),
                  Spacer(),

                  // Text(post.timestamp),
                  IconButton(
                    onPressed: () => _showOptions(),
                    icon: (Icon(Icons.more_vert, color: Colors.grey.shade800)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text(
                  widget.post.message,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.2,
                    color: Colors.black,
                  ),
                ),
              ),
              if (widget.post.image.isNotEmpty) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.post.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('Image failed to load'),
                  ),
                ),
              ],

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => bottomSheet().showPostDialog(
                        controller,
                        () => provider.storeCommentInFirebase(
                          widget.post.id,
                          controller.text,
                        ),
                      ),
                      child: actionRow(
                        icon: 'assets/chat.png',
                        count: comments != 0 ? comments.toString() : "",
                      ),
                    ),
                    actionRow(icon: 'assets/tweet.png', count: '32'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            toggleLike();
                          },
                          icon: isCurrentUser
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey.shade800,
                                ),
                        ),
                        Consumer<Userprovider>(
                          builder: (context, value, _) {
                            return Text(
                              value.getLikeCount(widget.post.id) != 0
                                  ? value
                                        .getLikeCount(widget.post.id)
                                        .toString()
                                  : '',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // actionRow(
                    //   icon: 'assets/heart.png',
                    //   count: widget.post.likecounts.toString(),
                    // ),
                    actionRow(icon: 'assets/bookmark.png', count: ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class actionRow extends StatelessWidget {
  final String count;
  final String icon;
  const actionRow({super.key, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon, width: 20, height: 20, color: Colors.grey.shade800),
        SizedBox(width: 6),
        Text(count, style: GoogleFonts.roboto()),
      ],
    );
  }
}
