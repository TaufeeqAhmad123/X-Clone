import 'package:cloud_firestore/cloud_firestore.dart';

class Postmodel {
  final String id;
  final String uid;
  final String name;
  final String userName;
  final String message;
  final String image;
  final String timestamp;
  final int likecounts;
  final List<String> likeBY;


  Postmodel({
    required this.id,
    required this.uid,
    required this.name,
    required this.userName,
    required this.message,
    required this.image,
    required this.timestamp,
    required this.likecounts,
    required this.likeBY,
    
    
  });
  Map<String, dynamic> toMap() {
    return {
     "id": id,
      'uid': uid,
      'name': name,
      'userName': userName,
      'message': message,
      'image': image,
      'timestamp': timestamp,
      'likecounts': likecounts,
      'likeBY': likeBY,
     

    };
  }
  factory Postmodel.empty() {
    return Postmodel(
      id: '',
      uid: '',
      name: '',
      userName: '',
      message: '',
      image: '',
      timestamp: '',
      likecounts: 0,
      likeBY: [],
    );
  }
  factory Postmodel.fromDocument(DocumentSnapshot doc) {
    return Postmodel(
      id: doc.id,
      uid: doc['uid'] ?? '',
      name: doc['name'] ?? '',
      userName: doc['userName'] ?? '',
      message: doc['message'] ?? '',
      image: doc['image'] ?? '',
      timestamp: doc['timestamp'] ?? '',
      likecounts: doc['likecounts'] ?? 0,
      likeBY: List<String>.from(doc['likeBY'] ?? []),
    );
  }
}