import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/Login/login.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/setting/setting.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final String uid = AuthenticationRepository().getCurrentUid();
  bool isLoading = true;
  UserModel? user;
 late final userProvider = Provider.of<Userprovider>(context, listen: false);
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
   
  user= await userProvider.loadUSerData(uid);
    setState(() {
     // user = userProvider.userModel;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<Userprovider>(context).userModel;

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user?.image != null
                      ? NetworkImage(user!.image!)
                      : const AssetImage('assets/user.png',) as ImageProvider,
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.settings, color: Colors.black),onPressed: () => Get.offAll(()=>SettingScreen()),),
              ],
            ),
            SizedBox(height: 10),
        
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: GoogleFonts.kanit(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user?.userName}'?? "",
                        style: GoogleFonts.kanit(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          //fontWeight: FontWeight.grey,
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '1k',
                  style: GoogleFonts.kanit(fontSize: 18, color: Colors.black),
                ),
                SizedBox(width: 5),
                Text(
                  'Following',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '1k',
                  style: GoogleFonts.kanit(fontSize: 18, color: Colors.black),
                ),
                SizedBox(width: 5),
                Text(
                  'Followers',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey.shade600),
            SizedBox(height: 20),
            buildItem(
              text: 'Profile',
              image: 'assets/user.png',
              onTap: () {}
              // Get.off(() => ProfileScareen()),
            ),
            buildItem(text: 'Premium', image: 'assets/logo.png', onTap: () {}),
            buildItem(
              text: 'Bookmarks',
              image: 'assets/marks.png',
              onTap: () {},
            ),
            buildItem(text: 'List', image: 'assets/list.png', onTap: () {}),
            buildItem(text: 'Job', image: 'assets/job.png', onTap: () {}),
            buildItem(text: 'Spaces', image: 'assets/space.png', onTap: () {}),
            buildItem(
              text: 'Logout',
              image: 'assets/space.png',
              onTap: () {
                AuthenticationRepository().Logout();
                
                Get.offAll(() => TwitterLoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class buildItem extends StatelessWidget {
  final String text;
  final String image;
  void Function()? onTap;
  buildItem({
    super.key,
    required this.text,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Image.asset(image, color: Colors.black, height: 20),
        title: Text(
          text,
          style: GoogleFonts.kanit(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
