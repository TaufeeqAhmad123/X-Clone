import 'package:cloud_firestore/cloud_firestore.dart';

class Commentmodel {
  final String id;
  final String postID;
  final String uid;
  final String name;
  final String userName;
  final String message;

  final String timestamp;

  Commentmodel({
    required this.id,
    required this.postID,
    required this.uid,
    required this.name,
    required this.userName,
    required this.message,

    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "postID": postID,

      'uid': uid,
      'name': name,
      'userName': userName,
      'message': message,

      'timestamp': timestamp,
    };
  }

  factory Commentmodel.fromDocument(DocumentSnapshot doc) {
    return Commentmodel(
      id: doc.id,
      postID: doc['postID'] ?? '',
      uid: doc['uid'] ?? '',
      name: doc['name'] ?? '',
      userName: doc['userName'] ?? '',
      message: doc['message'] ?? '',

      timestamp: doc['timestamp'] ?? '',
    );
  }
}
