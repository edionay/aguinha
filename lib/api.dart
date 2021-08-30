import 'dart:math';
import 'package:aguinha/aguinha_user.dart';
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
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (username.exists)
      return username.get('username');
    else
      throw 'User not found';
  }

  static setUsername(String nickname) async {
    String suffix = (Random().nextInt(8999) + 1000).toString();

    print(FirebaseAuth.instance.currentUser!.uid);
    print(nickname);
    print(suffix);

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'username': '$nickname#$suffix',
      'nickname': nickname,
      'suffix': suffix
    });
  }

  static Future<AguinhaUser> getUserByUsername(String username) async {
    if (username == null) throw 'Usuário inválido';
    final usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get();
    print(username);
    print(usersSnapshot.size);
    if (usersSnapshot.size > 0) {
      final user = AguinhaUser(
          usersSnapshot.docs[0].id,
          usersSnapshot.docs[0].get('nickname'),
          usersSnapshot.docs[0].get('suffix'));
      return user;
    } else
      throw 'Usuário não encontrado';
  }

  static Future<AguinhaUser> getCurrentUser() async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (usersSnapshot.exists) {
      final user = AguinhaUser(usersSnapshot.id, usersSnapshot.get('nickname'),
          usersSnapshot.get('suffix'));
      return user;
    } else
      throw 'Usuário não encontrado';
  }

  static Future<void> sendFriendshipRequest(AguinhaUser recipient) async {
    final senderSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    print(senderSnapshot.data());

    final sender = AguinhaUser(senderSnapshot.id,
        senderSnapshot.get('nickname'), senderSnapshot.get('suffix'));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(sender.uid)
        .collection('sentRequests')
        .doc(recipient.uid)
        .set({
      'nickname': recipient.nickname,
      'suffix': recipient.suffix,
      'username': recipient.getUsername()
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipient.uid)
        .collection('receivedRequests')
        .doc(sender.uid)
        .set({
      'nickname': sender.nickname,
      'suffix': sender.suffix,
      'username': sender.getUsername()
    });
  }
}
