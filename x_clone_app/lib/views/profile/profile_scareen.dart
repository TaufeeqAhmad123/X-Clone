import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/components/bottom_naN_bar.dart';
import 'package:x_clone_app/components/post_card.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/home/home.dart';

class ProfileScareen extends StatefulWidget {
  final Postmodel? post;
  final String uid;
  const ProfileScareen({super.key, required this.post, required this.uid});

  @override
  State<ProfileScareen> createState() => _ProfileScareenState();
}

class _ProfileScareenState extends State<ProfileScareen> {
  final String currentID = AuthenticationRepository().getCurrentUid();

  bool isLoading = true;
  UserModel? user;
  late final userProvider = Provider.of<Userprovider>(context, listen: false);
  late final provider = Provider.of<Userprovider>(context);

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {
    user = await userProvider.loadUSerData(currentID);

    setState(() {
      // user = userProvider.userModel;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allUserPost = provider.getAllPostForSingleuser(currentID);

    print(user);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.off(() => BottomNavBar()),
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(isLoading || user == null ? 'Loading...' : (user!.name)),
        ),
        body: isLoading || user == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user!.image),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      user!.name,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '@${user!.userName}',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user!.bio,
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: Colors.grey.shade900,
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 16),
                        SizedBox(width: 5),
                        Text(
                          'Joined : ${DateFormat('MMMM d,y').format(user!.date)}',
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          '1k',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Following',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '1k',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Followers',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'Posts',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Replies',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'highlight',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Articals',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        //Tab(child: Text('Media',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w700))),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          /// POSTS TAB
                          ListView.builder(
                            itemCount: allUserPost.length,
                            itemBuilder: (context, index) {
                              final post = allUserPost[index];
                              return Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                Colors.grey.shade400,
                                            child: Center(
                                              child: Icon(
                                                Iconsax.profile_add,
                                                color: Colors.black,
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
                                          Icon(
                                            Icons.more_vert,
                                            color: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 50,
                                        ),
                                        child: Text(
                                          post.message,
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 1.2,
                                            color: Colors.black,
                                          ),
                                        ),
                                        //Text(provider.postsList.length[index].toString()),
                                      ),
                                      if (post.image.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            post.image,
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Text(
                                                      'Image failed to load',
                                                    ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 50,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            actionRow(
                                              icon: 'assets/chat.png',
                                              count: provider.getComments(post.id)
                                                  .length
                                                  .toString(),
                                            ),
                                            actionRow(
                                              icon: 'assets/tweet.png',
                                              count: '32',
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                  
                                                  },
                                                  icon:provider.getLikeCount(post.id)==0 ? Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.grey.shade800,
                                                  ) : Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Consumer<Userprovider>(
                                                  builder: (context, value, _) {
                                                    return Text(
                                                      value.getLikeCount(
                                                                post.id,
                                                              ) !=
                                                              0
                                                          ? value
                                                                .getLikeCount(
                                                                  post.id,
                                                                )
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

                                            actionRow(
                                              icon: 'assets/bookmark.png',
                                              count: '',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          /// REPLIES TAB
                          Center(child: Text('Replies Tab')),

                          /// HIGHLIGHT TAB
                          Center(child: Text('Highlight Tab')),

                          /// ARTICLES TAB
                          Center(child: Text('Articles Tab')),
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
