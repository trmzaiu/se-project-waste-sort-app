import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../ScanAI/processImage.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../evidence/upload_evidence_screen.dart';

class ScanScreen extends StatefulWidget {
  final String imagePath;

  ScanScreen({required this.imagePath});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool _isScanning = false;
  String? _scanResult;
  bool _scanCompleted = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _scanImage() async {
    setState(() {
      _isScanning = true;
      _scanResult = null;
      _scanCompleted = false;
    });

    controller.repeat(reverse: true);

    String? result = await ApiService.classifyImage(File(widget.imagePath));

    setState(() {
      _isScanning = false;
      _scanCompleted = true;
      _scanResult = result;
    });

    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Image.file(
                  File(widget.imagePath),
                  // width: constraints.maxWidth,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          ),

          if (_isScanning)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scanning...",
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.surface,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        backgroundColor: Color(0xFFDEF3E7),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_scanCompleted && _scanResult != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    width: 280,
                    height: 82,
                    margin: EdgeInsets.only(bottom: 160),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 17),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            _scanResult == "Recyclable"
                              ? 'lib/assets/images/recycle.png'
                              : _scanResult == "Organic"
                              ? 'lib/assets/images/organic.png'
                              :_scanResult == "Hazardous"
                              ? 'lib/assets/images/hazard.png'
                              :_scanResult == "General"
                              ? 'lib/assets/images/general.png'
                              : 'lib/assets/images/caution.png',
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "CATEGORY",
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: AppFontWeight.regular,
                                color: Color(0xFFC2C2C2),
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _scanResult!,
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: AppFontWeight.medium,
                                color: Color(0xFF494949),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 17,
                    top: 19,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'lib/assets/icons/ic_backward.svg',
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (!_isScanning && !_scanCompleted)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _isScanning ? null : _scanImage,
                    child: Container(
                      width: 356,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Scan",
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadScreen(imagePath: widget.imagePath),
                        ),
                      );
                    },
                    child: Text(
                      "Upload Evidence",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: AppFontWeight.semiBold,
                        color: AppColors.surface,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Color(0xFF333333).withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),

          if (!_isScanning)
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  _scanCompleted ? Navigator.popUntil(context, (route) => route.isFirst) : Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF494848).withOpacity(0.5),
                  ),
                  child: SvgPicture.asset(
                    'lib/assets/icons/ic_close.svg',
                    height: 40,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
