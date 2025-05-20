import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/components/bottommodelsheed.dart';
import 'package:x_clone_app/components/post_card.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/comments/widget/comment_tile.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class CommentsScreen extends StatelessWidget {
  final Postmodel post;
  const CommentsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Userprovider>(context);
    late final databaseprovider = Provider.of<Userprovider>(
      context,
      listen: false,
    );

    void toggleLike() async {
      await provider.likePost(post.id);
    }

    final allComments = databaseprovider.getComments(post.id);
    int comments = databaseprovider.getComments(post.id).length;
    bool isCurrentUser = provider.isCurrentsUserLikePost(post.id);
    

    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: ListView(
        children: [
          Card(
            child: GestureDetector(
              onTap: () {
                // Handle post tap
              },
              child: PostTile(
                post: post,
                provider: provider,
                comments: comments,
                isCurrentUser: isCurrentUser,
                toggleLike: toggleLike,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: VerticalDivider(color: Colors.black26, thickness: 10),
          ),
          allComments.isEmpty
              ? Text('No Comments For The post')
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allComments.length,
                    itemBuilder: (context, index) {
                      final comment = allComments[index];
                      return CommentTile(post: post, comment: comment);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}



class PostTile extends StatelessWidget {
  PostTile({
    super.key,
    required this.post,
    required this.provider,
    required this.comments,
    required this.isCurrentUser,
    this.toggleLike,
  });

  final Postmodel post;
  final Userprovider provider;
  final int comments;
  final bool isCurrentUser;
  Function? toggleLike;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Get.to(() => ProfileScareen(post: post,uid: post.uid,));
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
              Text(
                post.name,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '@${post.userName}',
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
                  bottomSheet().showOptions(context, post, provider),
                },
                icon: (Icon(Icons.more_vert, color: Colors.grey.shade800)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              post.message,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                actionRow(
                  icon: 'assets/chat.png',
                  count: comments != 0 ? comments.toString() : '',
                ),
                actionRow(icon: 'assets/tweet.png', count: '32'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        toggleLike!();
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
                          value.getLikeCount(post.id) != 0
                              ? value.getLikeCount(post.id).toString()
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
    );
  }
}
