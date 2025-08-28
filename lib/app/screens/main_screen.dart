import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/theme_controller.dart';
import 'home_screen.dart';
import 'course_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final UserController userController = Get.find<UserController>();
  final ThemeController themeController = Get.find<ThemeController>();

  MainScreen({super.key});

  final List<Widget> screens = [
    HomeScreen(),
    CourseScreen(),
    ProfileScreen(),
  ];

  final List<String> titles = [
    "Trang chủ",
    "Khóa học",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(titles[mainController.currentIndex.value]),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: screens[mainController.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mainController.currentIndex.value,
        onTap: (index) => mainController.changeTab(index),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Khóa học"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    ));
  }
}
