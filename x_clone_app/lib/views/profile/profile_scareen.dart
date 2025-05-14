import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/home.dart';

class ProfileScareen extends StatefulWidget {
  const ProfileScareen({super.key});

  @override
  State<ProfileScareen> createState() => _ProfileScareenState();
}

class _ProfileScareenState extends State<ProfileScareen> {
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
    user = await userProvider.loadUSerData(uid);
    setState(() {
      // user = userProvider.userModel;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.off(() => HomeScreen()),
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
                    Text(user!.bio,style: GoogleFonts.roboto(
                            fontSize: 17,
                            color: Colors.grey.shade900,
                          ),),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,size: 16,),
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
                        Tab(child: Text('Posts',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),)),
                        Tab(child: Text('Replies',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w700))),
                        Tab(child: Text('highlight',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w700))),
                        Tab(child: Text('Articals',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w700))),
                        //Tab(child: Text('Media',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w700))),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          TabBarView(
                            children: [
                              Center(child: Text('Home Tab')),
                              Center(child: Text('Search Tab')),
                              Center(child: Text('Profile Tab')),
                            ],
                          ),
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
