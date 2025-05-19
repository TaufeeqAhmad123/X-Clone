import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String name;
  final String uid;
  final String email;
  final String userName;
  final String bio;
 
  final String image;
  final DateTime date;

  UserModel(
    {
    required this.name,
    required this.uid,
    required this.email,
   required  this.userName,
  required  this.bio,
  required  this.image,
  required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'userName': userName,
      'bio': bio,
      'image': image,
      'date': date,
    };
  }
factory UserModel.fromDocument(DocumentSnapshot doc){
  return UserModel(
    uid: doc['uid'] ?? '',
    name: doc['name'] ?? '',
    email: doc['email'] ?? '',
    userName: doc['userName'] ?? '',
    bio: doc['bio'] ?? '',
    image: doc['image'] ?? '',
    date: (doc['date'] as Timestamp).toDate(),
  );
}
}
