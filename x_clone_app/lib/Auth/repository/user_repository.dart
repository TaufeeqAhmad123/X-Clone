import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/utils/Exception/firebase_auth_exception.dart';
import 'package:x_clone_app/utils/Exception/firebase_exception.dart';
import 'package:x_clone_app/utils/Exception/formate_exception.dart';
import 'package:x_clone_app/utils/Exception/platfrom_exception.dart';
import 'package:x_clone_app/utils/Snackbar/snackbar.dart';
import 'package:x_clone_app/views/search/search.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final String collectionName = 'user';
  late String uid = _auth.currentUser!.uid;
  String imageurl = '';
  //store data into firebase

  Future<void> addUser(
    String name,
    String lastName,
    String email,
    String uid,
  ) async {
    final String username = email.split('@')[0];
    final String fullName = "$name $lastName";
    final DateTime today = DateTime.now();
    final DateTime onlyDate = DateTime(today.year, today.month, today.day);
     final String token = await MessageApi().getDeviceToken(); // FIXED ✅

    final user = UserModel(
      name: fullName,
      uid: uid,
      email: email,
      userName: username,
      bio: 'This is my bio',
      image: imageurl,
      date: onlyDate,
      FCMToken: token,
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

  Future<List<UserModel>> searchuserInFirebase(String searchitem) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('user')
          .where('userName', isGreaterThanOrEqualTo: searchitem)
          .where('userName', isLessThanOrEqualTo: '$searchitem\uf8ff')
          .get();
      return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
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
      return [];
    }
  }

  Future<UserModel?> updateUserProfile(
    String currentUserId,
    String name,
    image,
    bio,
  ) async {
    try {
      UserModel? user = await getUserDetails(currentUserId);

      await _db.collection('user').doc(uid).update({
        'image': image ?? user!.image,
        'name': name ?? user!.name,
        'bio': bio ?? user!.bio,
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
      print('Error getting user details: $e');
    }
  }

  Future<void> deleteuserDetail(String uid) async {
    try {
      WriteBatch batch = _db.batch();
      //delte user details
      DocumentReference userDoc = _db.collection('user').doc(uid);
      batch.delete(userDoc);
      //delete user post
      QuerySnapshot postDoc = await _db
          .collection('post')
          .where('uid', isEqualTo: uid)
          .get();
      for (var post in postDoc.docs) {
        batch.delete(post.reference);
      }
      //delete user comment
      QuerySnapshot commentDoc = await _db
          .collection('comments')
          .where('uid', isEqualTo: uid)
          .get();
      for (var post in commentDoc.docs) {
        batch.delete(post.reference);
      }
      //delete user likes
      QuerySnapshot likeDoc = await _db
          .collection('post')
          .where('likeBY', arrayContains: uid)
          .get();
      for (var post in likeDoc.docs) {
        List<String> likeBY = List<String>.from(post['likeBY'] ?? []);
        int currentLikeCount = post['likecounts'] ?? 0;
        if (likeBY.contains(uid)) {
          likeBY.remove(uid);
          currentLikeCount--;
        }
        batch.update(post.reference, {
          'likeBY': likeBY,
          'likecounts': currentLikeCount,
        });
      }

      await batch.commit();
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

  Future<void> repostUser(String postid, userId) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      final report = {
        'postID': postid,
        'postOwnerID': userId,
        'reportedBy': currentuserId,
        'timestamp': DateTime.now().toString(),
      };
      await _db.collection('report').add(report);
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

  Future<void> blockuser(String userId) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      await _db
          .collection('user')
          .doc(currentuserId)
          .collection('BlockUser')
          .doc(userId)
          .set({});
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

  Future<void> Unblockuser(String blockuserId) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      await _db
          .collection('user')
          .doc(currentuserId)
          .collection('BlockUser')
          .doc(blockuserId)
          .delete();
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

  Future<List<String>> getblockUserFromFirebase() async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      final snapshot = await _db
          .collection('user')
          .doc(currentuserId)
          .collection('BlockUser')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
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

  //Folow user
  Future<void> followuserInFirebase(String UID) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      await _db
          .collection('user')
          .doc(currentuserId)
          .collection('Following')
          .doc(UID)
          .set({});
      await _db
          .collection('user')
          .doc(UID)
          .collection('Follower')
          .doc(currentuserId)
          .set({});
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

  Future<void> unfollowuserInFirebase(String UID) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      await _db
          .collection('user')
          .doc(currentuserId)
          .collection('Following')
          .doc(UID)
          .delete();
      await _db
          .collection('user')
          .doc(UID)
          .collection('Follower')
          .doc(currentuserId)
          .delete();
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

  Future<List<String>> getFollowersfromFirebase(String UID) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      final snapshot = await _db
          .collection('user')
          .doc(UID)
          .collection('Follower')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
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

  Future<List<String>> getFollowinguserfromFirebase(String UID) async {
    try {
      final currentuserId = _auth.currentUser!.uid;

      final snapshot = await _db
          .collection('user')
          .doc(UID)
          .collection('Following')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
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

  Future<String> uploadImageToSupabase(File image) async {
    final fieldName = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'post/$fieldName.jpg';

    try {
      final storage = Supabase.instance.client.storage;

      await storage.from('images').upload(path, image);

      SnackbarUtil.successSnackBar(
        title: 'Image uploaded',
        message: 'Image uploaded successfully',
      );

      final imageUrl = storage.from('images').getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      print('Upload Error: $e');
      rethrow; // Or show error Snackbar
    }
  }

  Future<String> uploadprofileImageToSupabase(File image) async {
    final fieldName = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'User Profile/$fieldName';

    try {
      final storage = Supabase.instance.client.storage;

      await storage.from('images').upload(path, image);

      SnackbarUtil.successSnackBar(
        title: 'Image uploaded',
        message: 'Image uploaded successfully',
      );

      final imageUrl = storage.from('images').getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      print('Upload Error: $e');
      rethrow; // Or show error Snackbar
    }
  }
}

class MessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //request notification permission
  void requrstNotificationPermision() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,

      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    //final FCMToken = await _firebaseMessaging.getToken();
    getDeviceToken().then((value) {
      print('FCM Token: $value');
    });
  }

  //initialize local notification
  void initLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitalizationSettings = const AndroidInitializationSettings(
      '@drawable/image',
    );
    // Initialize the local notification settings for ios
    var iosInitalizationSettings = const DarwinInitializationSettings();
    //initiazlize the local notification setting for both android and ios
    var initializationSettings = InitializationSettings(
      android: androidInitalizationSettings,
      iOS: iosInitalizationSettings,
    );
// Initialize the local notification plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        handelmessage(context, message);

        // Handle notification click
      },
    );
  }

  // Show notification from firebase
  void firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
     
        print('Message received: ${message.notification?.title.toString()}');
        print('Message received: ${message.notification?.body.toString()}');
        print('Message data: ${ message.data.toString()}');
        print('Message typ: ${ message.data['type'].toString()}');
        print('Message id: ${ message.data['id'].toString()}');
      
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);

      }else{
                
      }
    });
  }

  //show notification when device is in foreground
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(1000000).toString(),
      'x_clone_app_channel',
    );
    AndroidNotificationDetails
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'This is the channel for X Clone App notifications',
      importance: Importance.high,
      priority: Priority.high,
     playSound: true,
      ticker: 'ticker' ,
    );
    DarwinNotificationDetails iosPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    Future.delayed(
      Duration.zero,(){
        _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title.toString(),
        message.notification?.body.toString(),
       
       
        
        notificationDetails,
      );
      }
      
    );
  }
  // Handle message when notification is clicked we redirect user to that screen mean if some comment is made on post so if user clicked on notification we redirect user to that post comment section
  // or if some message is sent to user so we redirect user to that message screen
  void handelmessage(
   BuildContext context, RemoteMessage message){

    if(message.data['type'] == 'msg') {
      // Navigate to post details page
      Get.to(()=>SearchScreen(uid: message.data['id'],));
    } else if (message.data['type'] == 'comment') {
      // Navigate to comment section of the post
      Navigator.pushNamed(
        context,
        '/postDetails',
        arguments: {
          'postId': message.data['id'],
          'scrollToComments': true,
        },
      );
    } else {
      // Handle other types of messages
      print('Unhandled message type: ${message.data['type']}');
    }

  }
//
Future<void> setupInterectMessage(BuildContext context)async{
  //when app is terminated mean kill
  RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
  if (initialMessage != null) {
    // Handle the message when the app is opened from a terminated state
    handelmessage(context, initialMessage);
  }
  //when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((event){
    handelmessage(context, event);

  });
}


  //get device token
  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh
        .listen((newToken) {
          print('New FCM Token: $newToken');
          newToken.toString();
        })
        .onError((err) {
          print('Error retrieving new FCM token: $err');
        });
  }
}
