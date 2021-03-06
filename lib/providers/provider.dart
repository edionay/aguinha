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
  bool hasUsername = false;

  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

      final userr = FirebaseAuth.instance.currentUser!;
      print('Firebase User');
      print(userr);

      final fmcToken = await FirebaseMessaging.instance.getToken();

      String locale = 'en_US';
      final String defaultLocale = Platform.localeName;
      if (supportedLanguages.contains(defaultLocale)) locale = defaultLocale;

      print(defaultLocale);

      FirebaseFirestore.instance
          .collection('users')
          .doc(userr.uid)
          .update({'locale': locale});

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
    } catch (error) {
      print('Deu erro');
      print(error);
    }
  }

  Future logout() async {
    googleSignIn.disconnect();
    final fmcToken = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tokens')
        .doc(fmcToken)
        .delete();

    await FirebaseAuth.instance.signOut();
  }
}

const supportedLanguages = ['pt_BR', 'en_US'];
