import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final userr = FirebaseAuth.instance.currentUser!;
    print('Firebase User');
    print(userr);

    final fmcToken = await FirebaseMessaging.instance.getToken();

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userr.uid)
        .collection('tokens')
        .doc(fmcToken);

    await ref.set({
      'token': fmcToken,
      'created': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
