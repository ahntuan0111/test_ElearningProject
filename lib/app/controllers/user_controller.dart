import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class UserController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedName = prefs.getString('username');
    final loggedInStatus = prefs.getBool('isLoggedIn') ?? false;

    if (loggedInStatus && storedEmail != null) {
      userEmail.value = storedEmail;
      userName.value = storedName ?? "Người dùng";
      isLoggedIn.value = true;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name cannot be blank";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be blank";
    }
    if (!GetUtils.isEmail(value)) {
      return "Email is not valid";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be blank";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> registerUser(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('email', emailController.text.trim());
      await prefs.setString('username', nameController.text.trim());
      await prefs.setString('password', passwordController.text.trim());
      await prefs.setBool('isLoggedIn', false);

      Get.snackbar("Success", "Register successfully!");
      await Future.delayed(Duration(milliseconds: 300)); // Chờ snackbar hiển thị
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> loginUser(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email');
      final savedPassword = prefs.getString('password');
      final savedName = prefs.getString('username');

      if (emailController.text == savedEmail &&
          passwordController.text == savedPassword) {
        await prefs.setBool('isLoggedIn', true);

        userName.value = savedName ?? "Người dùng";
        userEmail.value = savedEmail ?? "";
        isLoggedIn.value = true;

        Get.snackbar("Login", "Login successfully!");
        await Future.delayed(Duration(milliseconds: 300));
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.snackbar("Login", "Login failed! Email or Password incorrect");
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    isLoggedIn.value = false;

    Get.offAllNamed(AppRoutes.login);
  }
}
