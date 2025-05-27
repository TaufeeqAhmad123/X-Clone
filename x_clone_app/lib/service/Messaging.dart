import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/views/comments/comments_screen.dart';

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
      print('Message data: ${message.data.toString()}');
      print('Message typ: ${message.data['type'].toString()}');
      print('Message id: ${message.data['postID'].toString()}');

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else {}
    });
  }

  //show notification when device is in foreground
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(1000000).toString(),
      'x_clone_app_channel',
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription:
              'This is the channel for X Clone App notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
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
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title.toString(),
        message.notification?.body.toString(),

        notificationDetails,
      );
    });
  }

  // Handle message when notification is clicked we redirect user to that screen mean if some comment is made on post so if user clicked on notification we redirect user to that post comment section
  // or if some message is sent to user so we redirect user to that message screen
  void handelmessage(BuildContext context, RemoteMessage message) async {
    final type = message.data['type'];

    if (type == 'comment') {
      final postId = message.data['postID'];
      if (postId == null || postId.isEmpty) {
        print('postID is null or empty');
        return;
      }

      print('Post ID: $postId');
      Postmodel? post = await UserRepository().getPostById(postId);
      if (post != null) {
        Get.to(() => CommentsScreen(post: post));
      } else {
        // Handle case where post is not found
        print('Post not found for ID: $postId');
      }
    } else if (message.data['type'] == 'like') {
      // Navigate to comment section of the post
      Navigator.pushNamed(
        context,
        '/postDetails',
        arguments: {'postId': message.data['id'], 'scrollToComments': true},
      );
    } else {
      // Handle other types of messages
      print('Unhandled message type: ${message.data['type']}');
    }
  }

  //
  Future<void> setupInterectMessage(BuildContext context) async {
    //when app is terminated mean kill
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      // Handle the message when the app is opened from a terminated state
      handelmessage(context, initialMessage);
    }
    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
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
