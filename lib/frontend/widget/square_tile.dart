import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wastesortapp/theme/colors.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(10),
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: SvgPicture.asset(imagePath),
    );
  }
}
