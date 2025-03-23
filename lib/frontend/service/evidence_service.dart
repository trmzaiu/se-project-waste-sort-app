import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../ScanAI/processImage.dart';
import '../../database/CloudinaryConfig.dart';
import '../../database/model/evidence.dart';
import '../screen/evidence/evidence_screen.dart';
import '../utils/route_transition.dart';

class EvidenceService{
  final BuildContext context;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TreeService _treeService = TreeService();

  EvidenceService(this.context);

  Future<void> submitData({
   List<File>? selectedImages,
   String? selectedCategory,
   TextEditingController? descriptionController,
   int totalPoint = 5,
  }) async {
    if (selectedImages!.isEmpty) {
      showSnackBar("No image selected");
      return;
    }

    if (selectedCategory == null) {
      showSnackBar("Please select a category");
      return;
    }

    try {
      List<String> uploadedImageUrls = [];

      for (File image in selectedImages) {
        String? imageUrl = await CloudinaryConfig().uploadImage(image);
        if (imageUrl != null) {
          uploadedImageUrls.add(imageUrl);
        }
      }

      if (uploadedImageUrls.isEmpty) {
        showSnackBar("Image upload failed");
        return;
      }

      if (uploadedImageUrls.length == 5) {
        totalPoint += 10;
      } else if (uploadedImageUrls.length > 2) {
        totalPoint += 5;
      }

      if (descriptionController != null) {
        String description = descriptionController.text.trim();
        if (description.length >= 50) {
          totalPoint += 10;
        } else if (description.isNotEmpty) {
          totalPoint += 5;
        }
      }

      String evidenceId = _db.collection('evidences')
          .doc()
          .id;

      Evidences evidence = Evidences(
        userId: _auth.currentUser!.uid,
        evidenceId: evidenceId,
        category: selectedCategory,
        imagesUrl: uploadedImageUrls,
        description: descriptionController?.text.trim(),
        date: DateTime.now(),
        status: "Pending",
        point: totalPoint,
      );

      await FirebaseFirestore.instance
          .collection('evidences')
          .doc(evidenceId)
          .set(evidence.toMap());

      showSnackBar("Upload successful!", success: true);

      Navigator.of(context).pushAndRemoveUntil(
        moveLeftRoute(
          EvidenceScreen()),
          (route) => route.settings.name != "ScanScreen" || route.isFirst,
      );

      await _db.collection('evidences')
          .doc(evidenceId)
          .set(evidence.toMap());

      Future.delayed(Duration(seconds: 5), () async {
        await verifyEvidence(evidence);
      });
    } catch (e) {
      showSnackBar("Error uploading: $e");
    }
  }

  void showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.surface
            )
          ),
        ),
        backgroundColor: success ? AppColors.board2 : AppColors.board1,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Stream<List<Evidences>> fetchEvidences(String userId) {
    return _db.collection('evidences')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Evidences.fromFirestore(doc))
          .toList()
          ..sort((a, b) => b.date.compareTo(a.date)));
  }

  Future<void> verifyEvidence(Evidences evidence) async {
    try {
      bool allMatched = true;

      for (String imageUrl in evidence.imagesUrl) {
        File imageFile = await downloadImage(imageUrl);
        String? predictedCategory = await ApiService.classifyImage(imageFile);

        if (predictedCategory == null || predictedCategory != evidence.category) {
          allMatched = false;
          break;
        }
      }

      String newStatus = allMatched ? "Accepted" : "Rejected";

      await _db.collection('evidences')
          .doc(evidence.evidenceId)
          .update({'status': newStatus});

      showSnackBar("Evidence verified: $newStatus", success: true);

      var evidenceDoc = await _db.collection('evidences')
          .doc(evidence.evidenceId)
          .get();

      String? userId = evidenceDoc.data()?['userId'];
      int point = evidenceDoc.data()?['point'] ?? 0;

      if (userId != null) {
        String? treeId = await _treeService.getTreeIdByUserId(userId);

        if (treeId != null && newStatus == "Accepted") {
          await _treeService.increaseDrops(treeId, point);
        }
      }
    } catch (e) {
      print("Error verifying evidence: $e");
    }
  }

  Future<File> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception("Failed to download image");
    }
  }

}