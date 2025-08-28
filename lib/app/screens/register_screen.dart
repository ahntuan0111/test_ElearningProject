import 'package:flutter/material.dart';
import 'package:flutter_application_10/app/controllers/theme_controller.dart';
import 'package:flutter_application_10/app/controllers/user_controller.dart';
import 'package:flutter_application_10/app/routes/app_routes.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chính"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: userController.nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: userController.validateName,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: userController.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: userController.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    controller: userController.passwordController,
                    validator: userController.validatePassword,
                    obscureText: userController.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Enter Your Password",
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          userController.isPasswordVisible.value =
                              !userController.isPasswordVisible.value;
                        },
                        icon: Icon(
                          userController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    controller: userController.confirmPasswordController,
                    validator: userController.validateConfirmPassword,
                    obscureText: userController.isConfirmPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          userController.isConfirmPasswordVisible.value =
                          !userController.isConfirmPasswordVisible.value;
                        },
                        icon: Icon(
                          userController.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await userController.registerUser(_formKey);
                    },
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      elevation: 5,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  child: Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
