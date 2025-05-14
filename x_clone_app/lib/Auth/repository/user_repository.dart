import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:x_clone_app/model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final String collectionName = 'users';
  late String uid = _auth.currentUser!.uid;
String imageurl='https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400';
  Future<void> addUser(String name, String email) async {
    final String username = email.split('@')[0];
    final user = UserModel(
      name: name,
      uid: uid,
      email: email,
      userName: username,
      bio: 'This is my bio',
      image: imageurl,
    ).toMap();

    try {
      await _db.collection(collectionName).doc(uid).set(user);
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db
          .collection(collectionName)
          .doc(uid)
          .get();
      return UserModel.fromDocument(snapshot);
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }
}
