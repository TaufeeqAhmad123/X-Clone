import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/components/myFollowerTile.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/service/cloude_messaging_service.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class SearchScreen extends StatelessWidget {
  final String uid;
  SearchScreen({super.key, required this.uid});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Userprovider>(context);
    final databaseProvider = Provider.of<Userprovider>(context, listen: false);
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
              child: ElevatedButton(
                onPressed: () async {
                  final get = getCloudeMessagingService();
                  String token = await get.serverToken();
                  await http.post(
                    Uri.parse(
                        'https://fcm.googleapis.com/v1/projects/xclone-af992/messages:send'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode(<String, dynamic>{
                      "message": {
                        "token":
                            'dY8-xIdDRSeFzjBEJLkns4:APA91bGWxieRsLWtWlKBycj9LIMpvjPD3yDJjHrtHhMShDy_wlmV8Q_kMaWQJ75Vg63y8tknETF16iON4DH625NXPD0a_Bp1ceVWnGZMDpwPRvzP2WpQ3MY',
                        "notification": {
                          "body": 'This is the push notification',
                          "title": 'Push Notification',
                        },
                        "data": {"type": "msg", "id": "12345"},
                      }
                    }),
                  );
                  print('toen');
                },
                child: Text('Send Request'),
              ),
              //
              // Text(
              //   'No users found${uid}',
              //   style: TextStyle(fontSize: 18, color: Colors.black54),
              // ),
            )
          : Expanded(
              child: ListView.builder(
                itemCount: provider.searchUserList.length,
                itemBuilder: (context, index) {
                  final user = provider.searchUserList[index];
                  return myFollowerTile(user: user);
                },
              ),
            ),
    );
  }
}
