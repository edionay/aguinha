import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class API {
  static getSentRequests() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('sentRequests')
        .snapshots();
  }

  static getReceivedRequests() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('receivedRequests')
        .snapshots();
  }

  static Future<bool> hasUsername() async {
    final username = await FirebaseFirestore.instance
        .collection('usernames')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print(FirebaseAuth.instance.currentUser!.uid);
    if (username.exists)
      return true;
    else
      return false;
  }

  static Future<String> getUsername() async {
    final username = await FirebaseFirestore.instance
        .collection('usernames')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (username.exists)
      return username.get('username');
    else
      throw 'User not found';
  }

  static setUsername(String nickname) async {
    String suffix = (Random().nextInt(8999) + 1000).toString();
    print(suffix);

    return await FirebaseFirestore.instance
        .collection('usernames')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'username': '$nickname#$suffix',
    });
  }
}
