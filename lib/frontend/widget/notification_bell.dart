import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../service/notification_service.dart';

class NotificationBell extends StatelessWidget {
  final double size;

  const NotificationBell({
    Key? key,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: NotificationService().countUnreadNotifications(),
      builder: (context, snapshot) {
        // If the request is still loading, show no badge (or a placeholder if desired)
        int count = snapshot.data ?? 0;

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
                shadowColor: MaterialStateProperty.all(const Color(0x33333333)),
                elevation: MaterialStateProperty.all(2),
              ),
            ),
            // Only show the badge if there's at least one unread notification.
            if (count > 0)
              Positioned(
                left: 22,
                top: 7,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  constraints: const BoxConstraints(minWidth: 15),
                  child: Text(
                    count > 99 ? "99+" : count.toString(),
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      color: AppColors.surface,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
