import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:x_clone_app/components/myFollowerTile.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/provider/user_provider.dart';

class Followerslist extends StatefulWidget {
  final String uid;
  const Followerslist({super.key, required this.uid});

  @override
  State<Followerslist> createState() => _FollowerslistState();
}

class _FollowerslistState extends State<Followerslist> {
  late final provider = Provider.of<Userprovider>(context);
  late final databaseProvider = Provider.of<Userprovider>(
    context,
    listen: false,
  );

  @override
  initState() {
    super.initState();
    loadFollowers();
    loadFollowings();
  }

  Future<void> loadFollowers() async {
    await databaseProvider.loadFollowersProfile(widget.uid);
  }

  Future<void> loadFollowings() async {
    await databaseProvider.loadFollowingProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = provider.getListOfFollowersProfile(widget.uid);
    final following = provider.getListOfFollowingProfile(widget.uid);
    print('Followers: ${widget.uid}');
    print('Following: ${following.length}');
    return DefaultTabController(
      
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            bottom: TabBar(
              
              tabs: [
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildUerList(followers, 'No followers found'),
              _buildUerList(following, 'No following found'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUerList(List<UserModel> userList, String emptyMessage) {
    return userList.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return myFollowerTile(user: user);
            },
          );
  }
}


