import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/utils/Exception/firebase_auth_exception.dart';
import 'package:x_clone_app/utils/Exception/firebase_exception.dart';
import 'package:x_clone_app/utils/Exception/formate_exception.dart';
import 'package:x_clone_app/utils/Exception/platfrom_exception.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final String collectionName = 'user';
  late String uid = _auth.currentUser!.uid;
  String imageurl =
      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400';
  //store data into firebase
  Future<void> addUser(String name, String lastName, String email) async {
    final String username = email.split('@')[0];
    final String fullName = "$name $lastName";
    final DateTime today = DateTime.now();
    final DateTime onlyDate = DateTime(today.year, today.month, today.day);

    final user = UserModel(
      name: fullName,
      uid: uid,
      email: email,
      userName: username,
      bio: 'This is my bio',
      image: imageurl,
      date: onlyDate,
    ).toMap();

    try {
      await _db.collection(collectionName).doc(uid).set(user);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  //Get user details from Firestore
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db
          .collection(collectionName)
          .doc(uid)
          .get();
      return UserModel.fromDocument(snapshot);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  //Store Post in firebase

  Future<void> storePostInFirebase(
    String message, {
    String imageURL = "",
  }) async {
    String uid = _auth.currentUser!.uid;
    UserModel? user = await getUserDetails(uid);

    try {
      Postmodel newPost = Postmodel(
        id: '',
        uid: user!.uid,
        name: user.name,
        userName: user.userName,
        message: message,
        timestamp: DateTime.now().toString(),
        likecounts: 0,
        image: imageURL,
        likeBY: [],
      );
      Map<String, dynamic> postData = newPost.toMap();
      await _db.collection('post').add(postData);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error storing post: $e');
    }
  }

  //get post from firebase
  Future<List<Postmodel>> getAllPost() async {
    try {
      QuerySnapshot sbapshot = await _db
          .collection('post')
          .orderBy('timestamp', descending: true)
          .get();
      return sbapshot.docs.map((doc) => Postmodel.fromDocument(doc)).toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  Future<void> deletePostFromFirebase(String postID) async {
    try {
      await _db.collection('post').doc(postID).delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
    }
  }

  Future<void> toggleLikeInFirebase(String postID) async {
    try {
      DocumentReference postRef = _db.collection('post').doc(postID);

      await _db.runTransaction((trans) async {
        DocumentSnapshot postSnapshot = await trans.get(postRef);

        List<String> likeBY = List<String>.from(postSnapshot['likeBY'] ?? []);
        int currentLikeCount = postSnapshot['likecounts'] ?? 0;
        if (!likeBY.contains(uid)) {
          likeBY.add(uid);
          currentLikeCount++;
        } else {
          likeBY.remove(uid);
          currentLikeCount--;
        }
        trans.update(postRef, {
          'likeBY': likeBY,
          'likecounts': currentLikeCount,
        });
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
    }
  }

  Future<void> commentOnPost(String postID, message) async {
    String uid = _auth.currentUser!.uid;
    UserModel? user = await getUserDetails(uid);
    try {
      final newComment = Commentmodel(
        id: '',
        postID: postID,
        uid: uid,
        name: user!.name,
        userName: user.userName,
        message: message,
        timestamp: DateTime.now().toString(),
      ).toMap();
      await _db.collection('comments').add(newComment);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
    }
  }

  Future<void> deletecommentOnPost(String commentID) async {
    try {
      await _db.collection('comments').doc(commentID).delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
    }
  }

  Future<List<Commentmodel>> getCommentsfromFirebase(String postid) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('comments')
          .where('postID', isEqualTo: postid)
          .get();

      return snapshot.docs
          .map((doc) => Commentmodel.fromDocument(doc))
          .toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
    }
    return [];
  }

  Future<String> uploadPostImage(String path, XFile image) async {
    final _storage = FirebaseStorage.instance;
    try {
      final ref = _storage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error getting posts: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  String api = 'd9a2b3a1da30c0ab3eb1984a38bcd40d';
}
