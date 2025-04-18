import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/frontend/screen/user/setting_screen.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/frontend/widget/bar_title.dart';
import 'package:wastesortapp/main.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../service/user_service.dart';

import '../../service/evidence_service.dart';
import '../../service/tree_service.dart';
import '../../widget/active_challenge.dart';
import '../../widget/challenge_item.dart';
import '../challenge/challenges_screen.dart';
import '../evidence/evidence_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    await AuthenticationService().signOut();
    Navigator.of(context).pushReplacement(
      moveLeftRoute(
        MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);
    print("Height: ${getPhoneHeight(context)}");
    print("Width: ${getPhoneWidth(context)}");

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BarTitle(title: "Profile", textColor: AppColors.secondary, showNotification: true),

          SizedBox(height: 25),

          StreamBuilder<Map<String, dynamic>>(
            stream: UserService().getCurrentUser(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final user = snapshot.data ?? {
                'photoUrl': '',
                'name': userId.substring(0, 10),
                'email': '',
              };

              return Column(
                children: [
                  Container(
                    width: 125,
                    height: 125,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: user['photoUrl'] != '' ? CachedNetworkImageProvider(user['photoUrl']) : AssetImage('lib/assets/images/avatar_default.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 5,
                          color: AppColors.tertiary.withOpacity(0.8),
                        )
                      )
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    user['name'],
                    style: GoogleFonts.urbanist(
                      color: AppColors.secondary,
                      fontSize: 24,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),

                  Text(
                    user['email'],
                    style: GoogleFonts.urbanist(
                      color: AppColors.tertiary,
                      fontSize: 16,
                      fontWeight: AppFontWeight.regular,
                    ),
                  ),
                ]
              );
            }
          ),

          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                moveLeftRoute(
                  SettingScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              elevation: 0,
            ),
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColors.surface,
                fontSize: 14,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),

          SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Statistics',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<Map<String, int>>(
                          stream: TreeService().getUserDropsAndTrees(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _statistic('Drops', '0');
                            }

                            Map<String, int> data = snapshot.data ?? {};
                            int drops = data['drops'] ?? 0;

                            return _statistic('Drops', drops.toString());
                          },
                        ),

                        StreamBuilder<Map<String, int>>(
                          stream: TreeService().getUserDropsAndTrees(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _statistic('Trees', '0');
                            }

                            Map<String, int> data = snapshot.data ?? {};
                            int trees = data['trees'] ?? 0;

                            return _statistic('Trees', trees.toString());
                          },
                        ),

                        StreamBuilder<int>(
                          stream: EvidenceService(context).getTotalEvidences(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _statistic('Evidences', '0');
                            }

                            int totalAccepted = snapshot.data ?? 0;

                            return _statistic('Evidences', totalAccepted.toString());
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'History',
                          style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 20,
                            fontWeight: AppFontWeight.semiBold,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              moveLeftRoute(
                                EvidenceScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'See more',
                            style: GoogleFonts.urbanist(
                              color: AppColors.tertiary,
                              fontSize: 13,
                              fontWeight: AppFontWeight.regular,
                            ),
                          ),
                        )
                      ]
                    ),
                  ),

                  SizedBox(height: 10),

                  StreamBuilder<Map<String, int>>(
                    stream: EvidenceService(context).getTotalEachAcceptedCategory(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      Map<String, int> categoryCounts = snapshot.data ?? {
                        'Recyclable': 0,
                        'Organic': 0,
                        'Hazardous': 0,
                        'General': 0,
                      };

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _history(
                                  context,
                                  'lib/assets/images/recycle.png',
                                  'Recyclable \nWaste',
                                  categoryCounts['Recyclable']?.toString() ?? '0',
                                ),
                                _history(
                                  context,
                                  'lib/assets/images/organic.png',
                                  'Organic \nWaste',
                                  categoryCounts['Organic']?.toString() ?? '0',
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: phoneWidth - phoneWidth * 0.405 * 2 - 60),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _history(
                                  context,
                                  'lib/assets/images/hazard.png',
                                  'Hazardous \nWaste',
                                  categoryCounts['Hazardous']?.toString() ?? '0',
                                ),
                                _history(
                                  context,
                                  'lib/assets/images/general.png',
                                  'General \nWaste',
                                  categoryCounts['General']?.toString() ?? '0',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Active Challenges',
                          style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 20,
                            fontWeight: AppFontWeight.semiBold,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              moveLeftRoute(
                                ChallengesScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'See more',
                            style: GoogleFonts.urbanist(
                              color: AppColors.tertiary,
                              fontSize: 13,
                              fontWeight: AppFontWeight.regular,
                            ),
                          ),
                        )
                      ]
                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ActiveChallenge(
                      image: 'lib/assets/images/zero_waste_challenge.png',
                      type: 'Daily',
                      title: 'Zero Waste Challenge',
                      info: 'Reduce your waste for a whole week! Track your trash, use reusable items, and share your progress with #ZeroWasteWeek.',
                      attend: '345',
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Daily Recycler", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: 0.5,
                              color: Colors.green,
                              backgroundColor: Colors.grey[300],
                              minHeight: 10,
                            ),
                            const SizedBox(height: 8),
                            Text('Ends in 2 days', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () => _signOut(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(phoneWidth - 60, 0),
                    ),
                    child: Text(
                      'Log out',
                      style: GoogleFonts.urbanist(
                        color: AppColors.surface,
                        fontSize: 16,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 35),
                ],
              ),
            )
          )
        ],
      )
    );
  }

  Widget _statistic(String title, String number) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: AppFontWeight.semiBold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: 16,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _history(BuildContext context, String image, String title, String time) {
    double phoneWidth = getPhoneWidth(context);
    double containerSize = phoneWidth * 0.405;
    double paddingSize = phoneWidth * 0.04;

    return Container(
      width: phoneWidth * 0.405,
      height: phoneWidth * 0.405,
      padding: EdgeInsets.all(paddingSize * 0.9),
      decoration: ShapeDecoration(
        color: Color(0x80EBDCD6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(1, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: containerSize * 0.22,
                width: containerSize * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: paddingSize * 0.5),

              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: AppColors.secondary,
                  fontSize: containerSize * 0.095,
                  fontWeight: AppFontWeight.regular,
                  letterSpacing: 0.8,
                  height: 1.2
                ),
              ),
            ],
          ),

          SizedBox(height: paddingSize * 0.5),

          Expanded(
            child: Text(
              time,
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: containerSize * 0.34,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          ),

          Text(
            time == '1' ? 'Time' : 'Times',
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: containerSize * 0.09,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}