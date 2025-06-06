import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/models/leaderboard.dart';
import 'package:wastesortapp/services/user_service.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widgets/bar_title.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ValueNotifier<bool> _isCurrentUserVisibleNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isScrollingUpNotifier = ValueNotifier<bool>(false);
  late ScrollController _scrollController;
  final double _topContainer = 0;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        print('Scrolling Down');
        if (_isScrollingUpNotifier.value != false) {
          _isScrollingUpNotifier.value = false;
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        print('Scrolling Up');
        if (_isScrollingUpNotifier.value != true) {
          _isScrollingUpNotifier.value = true;
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final users = await UserService().showLeaderboard().first;
      final currentUserIndex = users.indexWhere((user) => user.userId == currentUserId);

      if (currentUserIndex != -1 && currentUserIndex < 10) {
        _isCurrentUserVisibleNotifier.value = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isCurrentUserVisibleNotifier.dispose();
    _isScrollingUpNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Leaderboard>>(
        stream: UserService().showLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading leaderboard'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No leaderboard data available'));
          }

          final users = snapshot.data!;

          return Column(
            children: [
              BarTitle(
                title: "Leaderboard",
                textColor: AppColors.secondary,
                showBackButton: true,
                buttonColor: AppColors.secondary,
                showNotification: true,
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: (1 - _topContainer * 2).clamp(0.0, 1.0),
                  child: AnimatedContainer(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    duration: Duration(milliseconds: 200),
                    height: (1 - _topContainer * 2).clamp(0.0, 1.0) * (getPhoneHeight(context) / 3.5),
                    width: getPhoneWidth(context),
                    child: FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          _buildTopThree(users)
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    // Handle scroll updates for visibility of current user
                    if (scrollInfo is ScrollUpdateNotification) {
                      int currentUserIndex = -1;
                      for (int i = 3; i < users.length; i++) {
                        if (users[i].userId == currentUserId) {
                          currentUserIndex = i;
                          break;
                        }
                      }

                      if (currentUserIndex >= 3) {
                        final itemHeight = 71.0;
                        final firstVisible = scrollInfo.metrics.pixels ~/ itemHeight;
                        final lastVisible = ((scrollInfo.metrics.pixels + scrollInfo.metrics.viewportDimension) ~/ itemHeight);
                        final adjustedIndex = currentUserIndex - 3;
                        final bool visible = adjustedIndex >= firstVisible && adjustedIndex <= lastVisible - (_isScrollingUpNotifier.value ? 1 : 0);
                        print('visible: ${(_isScrollingUpNotifier.value ? 1 : 0)}');
                        print('firstVisible: $firstVisible, lastVisible: $lastVisible, adjustedIndex: $adjustedIndex');

                        if (visible != _isCurrentUserVisibleNotifier.value) {
                          _isCurrentUserVisibleNotifier.value = visible;
                        }
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: users.length > 3 ? users.length - 3 : 0,
                    itemBuilder: (context, index) {
                      final user = users[index + 3];
                      return _buildUserTile(user);
                    },
                  ),
                ),
              ),
              // Current user tile at the bottom, shown based on scroll state
              ValueListenableBuilder<bool>(
                valueListenable: _isCurrentUserVisibleNotifier,
                builder: (context, isVisible, _) {
                  final shouldShowCurrentUser = !isVisible &&
                      users.any((user) => user.userId == currentUserId && user.rank > 3);

                  if (!shouldShowCurrentUser) {
                    return SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: _buildUserTile(
                      users.firstWhere((user) => user.userId  == currentUserId),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopThree(List<Leaderboard> users) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (users.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: _buildTopUser(users[1], AppColors.background, 75),
          )
        else
          SizedBox(),
        if (users.isNotEmpty)
          _buildTopUser(users[0], AppColors.background, 85)
        else
          SizedBox(),
        if (users.length > 2)
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: _buildTopUser(users[2], AppColors.background, 75),
          )
        else
          SizedBox(),
      ],
    );
  }

  Widget _buildTopUser(Leaderboard user, Color color, double avatarSize) {
    bool isCurrentUser = user.userId == currentUserId;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isCurrentUser ? AppColors.secondary : AppColors.surface, width: 3),
              ),
              child: CircleAvatar(
                backgroundImage: user.photoUrl != '' ? CachedNetworkImageProvider(user.photoUrl) : AssetImage('lib/assets/images/avatar_default.png'),
                radius: avatarSize / 2,
              ),
            ),

            Positioned(
              bottom: -10,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCurrentUser ? AppColors.secondary : AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      color: Color(0x40000000),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  user.rank.toString(),
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                    color: isCurrentUser ? AppColors.surface : AppColors.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 18),

        SizedBox(
          width: 100,
          child: Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: AppFontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.trees.toString(),
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: AppFontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(width: 5),
            Image.asset('lib/assets/images/tree.png', width: 12),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTile(Leaderboard user) {
    bool isCurrentUser = user.userId == currentUserId;

    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        color: isCurrentUser ? AppColors.secondary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 4,
            color: Color(0x33000000),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 25,
            alignment: Alignment.center,
            child: Text(
              user.rank.toString(),
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: AppFontWeight.bold,
                color: isCurrentUser ? AppColors.surface : AppColors.primary,
              ),
            ),
          ),

          SizedBox(width: 10),

          CircleAvatar(
            backgroundImage: user.photoUrl != '' ? CachedNetworkImageProvider(user.photoUrl) : AssetImage('lib/assets/images/avatar_default.png'),
            radius: 20,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              user.name,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: AppFontWeight.semiBold,
                color: isCurrentUser ? AppColors.surface : AppColors.primary,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                user.trees.toString(),
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                  color: isCurrentUser ? AppColors.surface : AppColors.primary,
                ),
              ),
              SizedBox(width: 5),
              Image.asset(
                'lib/assets/images/tree.png',
                width: 20,
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}