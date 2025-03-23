import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? get userId => _firebaseAuth.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> leaderboardStream() {
    return _firestore.collection('users').snapshots().asyncMap((userSnapshot) async {
      if (userSnapshot.docs.isEmpty) return [];

      Map<String, Map<String, dynamic>> usersData = {};
      for (var doc in userSnapshot.docs) {
        var data = doc.data();
        usersData[doc.id] = {
          'userId': doc.id,
          'name': data['name'] ?? 'Unknown',
          'image': data['photoUrl']?.isNotEmpty == true
              ? data['photoUrl']
              : 'lib/assets/images/avatar_default.png',
          'trees': 0 // Default tree count
        };
      }

      QuerySnapshot treeSnapshot = await _firestore.collection('trees').get();
      for (var doc in treeSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userId = data['userId']?.toString().trim() ?? '';
        if (usersData.containsKey(userId)) {
          usersData[userId]!['trees'] = (data['trees'] ?? 0);
        }
      }

      List<Map<String, dynamic>> leaderboardData = usersData.values.toList();
      leaderboardData.sort((a, b) => b['trees'].compareTo(a['trees']));

      for (int i = 0; i < leaderboardData.length; i++) {
        leaderboardData[i]['rank'] = i + 1;
      }

      return leaderboardData;
    });
  }
}
