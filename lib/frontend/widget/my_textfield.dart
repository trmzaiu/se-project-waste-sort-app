import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final double height;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          cursorColor: AppColors.secondary,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.tertiary),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.urbanist(fontSize: 13, color: AppColors.tertiary.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }
}
