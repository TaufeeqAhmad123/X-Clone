import 'package:flutter/material.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/views/home/home.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';
import 'package:x_clone_app/views/search/search.dart';

class BottomNavbarProvider with ChangeNotifier {
  int _currentIndex = 0;
 String get currentUserId => AuthenticationRepository().getCurrentUid();
  int get currentIndex => _currentIndex;
  

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  late final List<Widget> _screens;

  List<Widget> get screens => _screens;

 BottomNavbarProvider() {

  _screens = [
    HomeScreen(),
    SearchScreen(uid: currentUserId,),
    const Center(child: Text("Notifications")),
    ProfileScareen( uid: currentUserId,),
  ];
}
}
