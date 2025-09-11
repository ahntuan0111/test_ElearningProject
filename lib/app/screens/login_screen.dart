  import 'package:flutter/material.dart';
  import 'package:flutter_application_10/app/controllers/user_controller.dart';
  import 'package:flutter_application_10/app/routes/app_routes.dart';
  import 'package:get/get.dart';

  class LoginScreen extends StatelessWidget {
    final UserController userController = Get.find<UserController>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: userController.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: userController.validateEmail,
                ),
                SizedBox(height: 20),
                Obx(() => TextFormField(
                  controller: userController.passwordController,
                  obscureText: userController.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        userController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        userController.isPasswordVisible.value =
                        !userController.isPasswordVisible.value;
                      },
                    ),
                  ),
                  validator: userController.validatePassword,
                )),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await userController.loginUser(_formKey);
                    },
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
                    child: Text("Login"),
                  ),
                ),

                SizedBox(height: 20),
                TextButton(
                  onPressed: () => {
                    Get.toNamed(AppRoutes.register),
                    userController.nameController.clear(),
                    userController.emailController.clear(),
                    userController.passwordController.clear(),
                    userController.confirmPasswordController.clear(),
                  },
                  child: Text("Create new account"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
