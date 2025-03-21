import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/widget/bar_noti_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../utils/phone_size.dart';
import '../../widget/category_box.dart';
import '../../widget/challenge_item.dart';
import '../../widget/text_row.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final List<String> images = [
    "lib/assets/images/goodtoknow.png",
    "lib/assets/images/goodtoknow.png",
    "lib/assets/images/goodtoknow.png",
  ];

  final List<String> titles = [
    'Smart Solutions for Waste Sorting',
    'Why Recycling Matters?',
    'Eco-Friendly Waste Disposal Tips',
  ];

  final List<String> dates = [
    'January 12, 2022',
    'February 05, 2022',
    'March 18, 2022',
  ];

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            BarNotiTitle(title_small: "Hello", title_big: "EcoTrack"),

            SizedBox(height: 25),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: phoneWidth - 40,
                          height: 170,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-1, -1),
                              end: Alignment(1, 1),
                              colors: [Color(0xFF2C6E49), Color(0xFF5F8E6E)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset("lib/assets/images/sethomemade.png", height: phoneWidth - 40 - 180),
                          )
                        ),
                        Positioned(
                          top: 25,
                          left: 22,
                          child: SizedBox(
                            width: 135,
                            height: 40,
                            child: Text(
                              'Have you sorted waste today?',
                              style: GoogleFonts.urbanist(
                                color: AppColors.surface,
                                fontSize: 17,
                                fontWeight: AppFontWeight.bold,
                                height: 0.9,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          left: 22,
                          child: SizedBox(
                            width: 130,
                            height: 40,
                            child: Text(
                              'Upload your evidence \nto get bonus point.',
                              style: GoogleFonts.urbanist(
                                color: AppColors.surface,
                                fontSize: 12,
                                fontWeight: AppFontWeight.regular,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 22,
                          left: 22,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadScreen(imagePath: ""),
                                ),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 28,
                              padding: const EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                color: AppColors.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Upload',
                                  style: GoogleFonts.urbanist(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: AppFontWeight.semiBold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Categories",
                          style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      )
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryBox(image: 'lib/assets/icons/ic_recyclable.svg', text: 'Recyclable', slide: 0,),
                          CategoryBox(image: 'lib/assets/icons/ic_organic.svg', text: 'Organic', slide: 1,),
                          CategoryBox(image: 'lib/assets/icons/ic_hazardous.svg', text: 'Hazardous', slide: 2,),
                          CategoryBox(image: 'lib/assets/icons/ic_general.svg', text: 'General', slide: 3,),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextRow(text: 'Good to know'),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      width: phoneWidth - 40,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 3,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: phoneWidth - 40,
                                height: 100,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(images[index]),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15, top: 5, bottom: 12),
                                width: phoneWidth - 40,
                                height: 60,
                                decoration: ShapeDecoration(
                                  color: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x0C000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 1),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      titles[index],
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.secondary,
                                        fontSize: 16,
                                        fontWeight: AppFontWeight.semiBold,
                                      ),
                                    ),
                                    Text(
                                      dates[index],
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.tertiary,
                                        fontSize: 12,
                                        fontWeight: AppFontWeight.light,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          width: _currentIndex == index ? 15 : 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _currentIndex == index ? AppColors.secondary : Color(0xFFC4C4C4),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextRow(text: 'Challenges'),
                    ),

                    SizedBox(height: 30),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ChallengeItem(
                        image: 'lib/assets/images/zero_waste_challenge.png',
                        title: 'Zero Waste Challenge',
                        info: 'Reduce your waste for a whole week! Track your trash, use reusable items, and share your progress with #ZeroWasteWeek.',
                      ),
                    ),

                    SizedBox(height: 35),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ChallengeItem(
                        image: 'lib/assets/images/trash_to_treasure_challenge.png',
                        title: 'Trash to Treasure Challenge',
                        info: 'Turn waste into something useful! Up cycle old materials into creative DIY products and share with #TrashToTreasure.',
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}


