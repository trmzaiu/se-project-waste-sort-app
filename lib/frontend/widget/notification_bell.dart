import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class NotificationBell extends StatelessWidget {
  final double size;

  const NotificationBell({
    Key? key,
    this.size = 24
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              moveLeftRoute(
                NotificationScreen(),
              ),
            );
          },
          icon: SvgPicture.asset(
            'lib/assets/icons/ic_notification.svg',
            width: size,
            height: size,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.surface),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            shadowColor: MaterialStateProperty.all(Color(0x33333333)),
            elevation: MaterialStateProperty.all(2),
          ),
        ),

        Positioned(
          left: 22,
          top: 7,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30)
            ),
            constraints: BoxConstraints(
                minWidth: 15
            ),
            child: Text(
              "99+",
              style: GoogleFonts.urbanist(
                  fontSize: 10,
                  color: AppColors.surface,
                  height: 1
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
