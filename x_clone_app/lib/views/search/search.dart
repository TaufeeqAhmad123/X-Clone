
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/components/myFollowerTile.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class SearchScreen extends StatelessWidget {
  final String uid ;
   SearchScreen({super.key, required this.uid});
final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<Userprovider>(context);
    final databaseProvider=Provider.of<Userprovider>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
       
        backgroundColor: Colors.grey[300],
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search here...',
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            if (value.isNotEmpty) {
              databaseProvider.searchUser(value);
            } else {
              databaseProvider.searchUser('');
            }
          },
        ),
      ),
      body: provider.searchUserList.isEmpty
          ? Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : Expanded(
            child: ListView.builder(
                itemCount: provider.searchUserList.length,
                itemBuilder: (context, index) {
                  final user = provider.searchUserList[index];
                  return 
                    
                     myFollowerTile(user: user);
                },
              ),
          ),
    );
  }
}