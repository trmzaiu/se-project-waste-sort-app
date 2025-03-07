import 'package:flutter/material.dart';
import 'package:wastesortapp/components/square_tile.dart';
import 'package:wastesortapp/components/my_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {
    // Implement login logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5FEF2EC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Background with Image
              Container(
                width: 414,
                height: 396,
                decoration: BoxDecoration(
                  color: Color(0xFF7C3F3E),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 370,
                    height: 370,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/370x370"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
              

              // Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Label
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Color(0xFF9C9385),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Email Input Field
                    Container(
                      width: 330,
                      height: 49,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFCFB),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: InputBorder.none,
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Password Label
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF9C9385),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Password Input Field
                    Container(
                      width: 330,
                      height: 49,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFCFB),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Color(0x7F7C3F3E),
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Login Button
                    GestureDetector(
                      onTap: signUserIn,
                      child: Container(
                        width: 330,
                        height: 49,
                        decoration: ShapeDecoration(
                          color: Color(0xFF2C6E49),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Color(0xFF2C6E49)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFFF3F5F1),
                            fontSize: 18,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            height: 1.11,
                            letterSpacing: -0.23,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // "Or sign in with" Divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFF805A35),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or sign in with',
                            style: TextStyle(
                              color: Color(0xFF805A35),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF805A35),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(imagePath: 'assets/images/google.png'),
                        SizedBox(width: 45.47),
                        SquareTile(imagePath: 'assets/images/apple.png'),
                        SizedBox(width: 45.47),
                        SquareTile(imagePath: 'assets/images/facebook.png'),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Register Text
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Color(0xFF2C6E49)),
                              ),
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                  color: Color(0xFF7C3F3E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
