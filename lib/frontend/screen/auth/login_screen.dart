import 'package:flutter/material.dart';
import 'package:wastesortapp/components/square_tile.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/theme/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {
    // Implement login logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                      image: DecorationImage(
                        image: AssetImage("lib/assets/images/trash.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Centered Column for Login Form & Register Text
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Login Form
                  Container(
                    width: 350,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary),
                        ),
                        SizedBox(height: 30),

                        MyTextField(
                          controller: usernameController,
                          hintText: "Email",
                          obscureText: false,
                        ),
                        SizedBox(height: 30),

                        MyTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                        ),
                        SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot your password?",
                              style: TextStyle(color: AppColors.secondary)),
                        ),
                        SizedBox(height: 30),

                        GestureDetector(
                          onTap: signUserIn,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text("Login",
                                style: TextStyle(
                                    color: AppColors.surface,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),

                        SizedBox(height: 30),

                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: AppColors.secondary, thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Or sign in with",
                                  style: TextStyle(color: AppColors.secondary)),
                            ),
                            Expanded(
                                child: Divider(
                                    color: AppColors.secondary, thickness: 1)),
                          ],
                        ),
                        SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SquareTile(
                                imagePath: 'lib/assets/images/facebook.png'),
                            SizedBox(width: 30),
                            SquareTile(
                                imagePath: 'lib/assets/images/google.png'),
                            SizedBox(width: 30),
                            SquareTile(
                                imagePath: 'lib/assets/images/apple.png'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60), // Space between login form & register text

                  // "Don't have an account? Register"
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: AppColors.primary)),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } //  Closing bracket for `build` method

} //  Closing bracket for `LoginScreen` class
