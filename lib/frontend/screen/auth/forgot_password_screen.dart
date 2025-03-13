import 'package:flutter/material.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage; // Error message state

  void resetPassword() {
    setState(() {
      if (passwordController.text != confirmPasswordController.text) {
        errorMessage = "Passwords do not match"; // Set error message
      } else {
        errorMessage = null;
        // Proceed with password reset logic
        print("Password reset successful");
      }
    });
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
                        image: AssetImage("lib/assets/images/reset_password.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reset Password Form
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                width: 370,
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
                    // 👇 Add the bar here 👇
                    Container(
                      width: 90,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: Color(0xFF7C3F3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Reset Password",
                      style: GoogleFonts.urbanist(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Enter your new password and confirm it below.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(color: AppColors.secondary),
                    ),
                    SizedBox(height: 30),

                    // Password Text Field
                    MyTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    SizedBox(height: 20),

                    // Confirm Password Text Field
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),
                    SizedBox(height: 10),

                    // Error message (if passwords don't match)
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          errorMessage!,
                          style: GoogleFonts.urbanist(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    SizedBox(height: 20),

                    // Confirm Button
                    GestureDetector(
                      onTap: () {
                        resetPassword();
                        Navigator.pushNamed(context, '');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.urbanist(
                              color: AppColors.surface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Back to Login
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        "Back to Login",
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
