import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';

import 'package:x_clone_app/components/my_drawer.dart';
import 'package:x_clone_app/components/post_card.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/service/Messaging.dart';
import 'package:x_clone_app/service/cloude_messaging_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Postmodel? post;
  FirebaseAuth auth = FirebaseAuth.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController postController = TextEditingController();
  late final userProvider = Provider.of<Userprovider>(context, listen: false);
  late final provider = Provider.of<Userprovider>(context);
  @override
  void initState() {
    super.initState();
    MessageApi().firebaseInit(context);
   // MessageApi().setupInterectMessage(context);
    loadAllPost();
    final token=getCloudeMessagingService().serverToken();
    token.then((value) {
      print('Server Token: $value');
    }).catchError((error) {
      print('Error getting server token: $error');
    });
  }

  Future<void> loadAllPost() async {
    userProvider.getAllPostFromFirebase();
  }

  Future<void> postMessage() async {
    String message = postController.text.trim();
    if (message.isNotEmpty) {
      await userProvider.postMessage(message);
      postController.clear();
    }
  }

  void logout() async {
    try {
      await AuthenticationRepository().Logout().then(
        (value) => Get.off(() => TwitterLoginPage()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: floatingActionButton(context),
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/logo.png', height: 30),
          actions: [
            IconButton(
              onPressed: () {
                provider.logout();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TwitterLoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'For You'),
              Tab(text: 'Following'),
            ],
          ),
        ),

        drawer: MyDrawer(),
        body: TabBarView(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemCount: provider.postsList.length,
                itemBuilder: (context, index) {
                  final post = provider.postsList[index];
                  return postCard(post: post);
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemCount: provider.folloeingPost.length,
                itemBuilder: (context, index) {
                  final post = provider.folloeingPost[index];
                  return postCard(post: post);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () {
        showBottomSheet(
          context: context,

          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: double.infinity,
              child: Consumer<Userprovider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.cancel_outlined, size: 35),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Spacer(),
                          CupertinoButton(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            sizeStyle: CupertinoButtonSize.medium,
                            child: Center(
                              child: Text(
                                'Post',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              postMessage();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Center(child: Icon(Icons.person)),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: postController,
                              cursorColor: Colors.blue,
                              cursorHeight: 30,
                              cursorWidth: 2,
                              style: GoogleFonts.roboto(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                              maxLines: 7,

                              decoration: InputDecoration(
                                hintText: 'What\'s happening?',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 25,
                                  color: Colors.grey.shade600,
                                ),

                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (provider.imageFile != null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(provider.imageFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          userProvider.pickimage();
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 2,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Iconsax.camera,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
