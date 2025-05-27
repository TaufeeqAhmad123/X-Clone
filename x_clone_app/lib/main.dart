import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/firebase_options.dart';
import 'package:x_clone_app/provider/bottom_navBar_provider.dart';
import 'package:x_clone_app/provider/login_provider.dart';
import 'package:x_clone_app/provider/signup_provider.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/views/authGate.dart';
//
@pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
//   await Firebase.initializeApp();
// }

void main( ) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 

  await Supabase.initialize(
    url: 'https://nuaeiuvcwtqpeueszeps.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51YWVpdXZjd3RxcGV1ZXN6ZXBzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4NDc2NzAsImV4cCI6MjA2MzQyMzY3MH0.PWh2vie2Fqz32q0lQncmmkC7FClMPzduZhz8EgfhDiE',
  );
MessageApi().requrstNotificationPermision();
MessageApi().isTokenRefresh();
FirebaseMessaging.onBackgroundMessage(firebasemessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => Userprovider()),
        ChangeNotifierProvider(create: (context) => BottomNavbarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
@pragma('vm:entry-point')
Future<void> firebasemessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("✅ Handling a background message: ${message.messageId}");
  print("🔔 Title: ${message.notification?.title}");
  print("📩 Body: ${message.notification?.body}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'X Clone',
         
          home: const Authgate(),
        );
      },
    );
  }
}
