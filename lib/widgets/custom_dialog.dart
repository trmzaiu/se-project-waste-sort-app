import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final bool status;
  final String buttonTitle;
  final VoidCallback? onPressed;
  final bool? isDirect;
  final String? buttonTitle2;
  final VoidCallback? onPressed2;

  const CustomDialog({
    super.key,
    required this.message,
    required this.status,
    required this.buttonTitle,
    this.onPressed,
    this.isDirect,
    this.buttonTitle2,
    this.onPressed2
  });

  @override
  Widget build(BuildContext context) {
    double phoneHeight = getPhoneHeight(context);
    double phoneWidth = getPhoneWidth(context);

    return AlertDialog(
      backgroundColor: AppColors.background,
      contentPadding: EdgeInsets.fromLTRB(phoneWidth * 0.05, phoneWidth/7, phoneWidth * 0.05, 0),
      content: SizedBox(
        height: phoneHeight/2.7,
        width: phoneWidth - 60,
        child: Column(
          children: [
            SvgPicture.asset(
              status ? "lib/assets/icons/ic_green.svg" : "lib/assets/icons/ic_red.svg",
              width: phoneHeight/4,
              height: phoneHeight/4,
            ),
            SizedBox(height: phoneHeight * 0.03),
            Text(
              status ? "Success!" : "Oops!",
              style: GoogleFonts.urbanist(
                fontSize: phoneWidth * 0.6 * 0.1,
                color: status ? AppColors.primary : AppColors.secondary,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: GoogleFonts.urbanist(
                fontSize: phoneWidth * 0.45 * 0.1,
                color: AppColors.tertiary,
                fontWeight: AppFontWeight.regular,
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: phoneHeight * 0.05),
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDirect == true)
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Container(
                    height: phoneWidth * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: AppColors.surface,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ),
                ),
              ),

            Expanded(
              child: TextButton(
                onPressed: onPressed ?? () => Navigator.of(context).pop(),
                child: Container(
                  height: phoneWidth * 0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: status ? AppColors.primary : AppColors.secondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    buttonTitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: AppColors.surface,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}