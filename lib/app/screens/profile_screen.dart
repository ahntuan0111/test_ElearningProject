import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final ThemeController themeController = Get.put(ThemeController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar + Tên
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Text(
                        userController.userName.value.isNotEmpty
                            ? userController.userName.value[0].toUpperCase()
                            : "U",
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userController.userName.value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userController.userEmail.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Thông tin chi tiết
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: const Text("Username"),
                      subtitle: Text(userController.userName.value),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.orange),
                      title: const Text("Email"),
                      subtitle: Text(userController.userEmail.value),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: const Text("Phone"),
                      subtitle: const Text("+84 123 456 789"), // Có thể thêm field phone sau
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dark / Light Mode
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Obx(() => SwitchListTile(
                  title: Text(
                    themeController.isDarkMode.value
                        ? "Dark Mode"
                        : "Light Mode",
                  ),
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.toggleTheme(),
                  secondary: Icon(themeController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode),
                )),
              ),
              const SizedBox(height: 25),

              // Nút đăng xuất
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => userController.logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
