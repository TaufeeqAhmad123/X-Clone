import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class myFollowerTile extends StatelessWidget {
  const myFollowerTile({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.image),
        ),
        title: Text(user.name),
        subtitle: Text(user.userName),
        onTap: () {
          Get.to(() => ProfileScareen(uid: user.uid,));
        },
      ),
    );
  }
}