import 'package:flutter/material.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/views/home/home.dart';
import 'package:x_clone_app/views/profile/profile_scareen.dart';

class BottomNavbarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    HomeScreen(),
    const Center(child: Text("Search")),
    const Center(child: Text("Notifications")),
    ProfileScareen(post: null, uid: '',),
  ];
  List<Widget> get screens => _screens;
}
