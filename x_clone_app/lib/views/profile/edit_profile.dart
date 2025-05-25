import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/provider/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? user;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

 
  late final databaseprovider = Provider.of<Userprovider>(
    context,
    listen: false,
  );
  bool isLoading = false;
  String currentUid = AuthenticationRepository().getCurrentUid();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaduserData();
  }

  Future<void> loaduserData() async {
    user = await databaseprovider.loadUSerData(widget.uid);
    if (user != null) {
      nameController.text = user!.name;
      bioController.text = user!.bio;
    }
    
  }

  @override
  Widget build(BuildContext context) {
      final provider = Provider.of<Userprovider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                isLoading || user == null
                    ? Center(child: CircularProgressIndicator())
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: provider.profileImage != null
                            ? FileImage(provider.profileImage!)
                            : (user!.image.isNotEmpty
                                      ? NetworkImage(user!.image)
                                      : const AssetImage(
                                          'assets/user.png',
                                        ))
                                  as ImageProvider,
                      ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      provider.pickProfileImage();
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            editTextField(
              hinttext: 'Name',
              line: 1,
              controller: nameController,
            ),
            const SizedBox(height: 16),
            editTextField(hinttext: 'Bio', line: 3, controller: bioController),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(MediaQuery.of(context).size.width, 70),
              ),
              onPressed: () async {
                final name = nameController.text.trim().isEmpty
                    ? null
                    : nameController.text.trim();
                final bio = bioController.text.trim().isEmpty
                    ? null
                    : bioController.text.trim();

                setState(() => isLoading = true);

                await databaseprovider.updateUserProfile(currentUid, name, bio);
              await  loaduserData();

                setState(() => isLoading = false);

                // Optional: Show a snackbar or navigate back
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully')),
                );
              },
              child: Text(
                'Save Changes',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class editTextField extends StatelessWidget {
  final String hinttext;
  final int line;
  final TextEditingController controller;
  const editTextField({
    super.key,
    required this.hinttext,
    required this.line,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: line,
      controller: controller,
      style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: hinttext,
        hintText: 'Enter your $hinttext',
        labelStyle: const TextStyle(color: Colors.blue, fontSize: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
