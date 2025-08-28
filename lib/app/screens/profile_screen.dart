import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Center(
                child: Text(
                  userController.nameController.text.isNotEmpty
                      ? userController.nameController.text[0].toUpperCase()
                      : "U",
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text("User Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),
          Text("Username: ${userController.nameController.text}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Email: ${userController.emailController.text}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          const Text("Phone: +84 123 456 789", style: TextStyle(fontSize: 18)),
          Obx(() => SwitchListTile(
            title: Text(
              themeController.isDarkMode.value ? "Dark Mode" : "Light Mode",
              style: const TextStyle(fontSize: 16),
            ),
            value: themeController.isDarkMode.value,
            onChanged: (value) => themeController.toggleTheme(),
            secondary: Icon(themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
          )),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => userController.logout(),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
