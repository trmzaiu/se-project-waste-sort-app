import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastesortapp/services/tree_service.dart';

import '../../models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseFirestore _firestore;

  AuthenticationService()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn(),
        _facebookAuth = FacebookAuth.instance,
        _firestore = FirebaseFirestore.instance;

  AuthenticationService.test({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = auth,
        _firestore = firestore,
        _googleSignIn = GoogleSignIn(),
        _facebookAuth = FacebookAuth.instance;

  /// Function sign in with email & password
  Future<void> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await addToken(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Function sign up with email & password
  Future<void> signUp({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await saveUserInformation(
        userId: userCredential.user!.uid,
        name: userCredential.user!.uid.substring(0, 10),
        email: email,
      );

      await addToken(userCredential.user!.uid);

      await TreeService().createTree(userCredential.user!.uid);
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Function sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(code: 'sign-in-cancelled', message: 'Google Sign-In was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await saveUserInformation(
            userId: user.uid,
            name: user.displayName ?? user.uid.substring(0, 10),
            email: user.email ?? "",
          );

          await TreeService().createTree(user.uid);
        }

        await addToken(user.uid);
      }

    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Function sign in with Facebook
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
        throw FirebaseAuthException(code: 'sign-in-cancelled', message: 'Facebook Sign-In was cancelled.');
      }

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          final userData = await _facebookAuth.getUserData();
          await saveUserInformation(
            userId: user.uid,
            name: userData['name'] ?? user.uid.substring(0, 10),
            email: user.email ?? "",
          );

          await TreeService().createTree(user.uid);
        }

        await addToken(user.uid);
      }

    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Update the user password
  Future<void> updateUserPassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }
    await user.updatePassword(newPassword);
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    } catch (e) {
      throw Exception("Sign-out failed. Please try again.");
    }
  }

  /// Save user information to Firebase
  Future<void> saveUserInformation({
    required String userId,
    required String name,
    required String email,
  }) async {
    final userDocRef = _firestore.collection('users').doc(userId);

    Usr user = Usr(
      userId: userId,
      name: name,
      email: email,
      dob: DateTime.now(),
      photoUrl: "",
      country: "",
      completedDailyDate: null,
      completedWeekly: false,
      streak: 0,
      weekLog: "",
      weekProgress: 0,
      weekTasks: [],
    );

    await userDocRef.set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      // Handle errors
      print("Error sending password reset email: $e");
      return false;
    }
  }

  /// Add fcm token
  Future<void> addToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      // First, check if the document exists
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // If the document exists, update the fcmToken field
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': token,
        });
        print('✅ FCM token updated for user $userId');
      } else {
        // If the document doesn't exist, set the document with fcmToken
        await _firestore.collection('users').doc(userId).set({
          'fcmToken': token,
        });
        print('✅ FCM token set for new user $userId');
      }
    }
  }
}
