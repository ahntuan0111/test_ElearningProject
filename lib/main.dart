import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/controllers/main_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/controllers/user_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Khởi tạo GetX controllers
  Get.put(ThemeController());
  Get.put(UserController());
  Get.put(MainController());

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final ThemeController themeController = Get.find<ThemeController>();

  MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Learning App',
        initialRoute: isLoggedIn ? AppRoutes.main : AppRoutes.login,
        getPages: AppPages.routes,
        theme: themeController.theme,
      );
    });
  }
}
