import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/provider/user_provider.dart';

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
   
   user= await userProvider.loadUSerData(uid);
    setState(() {
     // user = userProvider.userModel;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Loading...' : (user!.name)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 50),
                Text(user!.userName),
               // Text(user?.userName ?? "No Username"),
              ],
            ),
    );
  }
}
