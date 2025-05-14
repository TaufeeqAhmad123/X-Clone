import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/provider/bottom_navBar_provider.dart';


class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavbarProvider>(context);
   return Scaffold(
        body: provider.screens[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.setCurrentIndex(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
