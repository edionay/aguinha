import 'dart:math';
import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
    nickname = nickname.trim();
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
    final usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get();
    if (usersSnapshot.size > 0) {
      final user = AguinhaUser(
          usersSnapshot.docs[0].id,
          usersSnapshot.docs[0].get('nickname'),
          usersSnapshot.docs[0].get('suffix'));
      return user;
    } else
      throw 'usuário não encontrado';
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
      throw 'usuário não encontrado';
  }

  static Future<String> getCurrentUserLocale() async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (usersSnapshot.exists) {
      try {
        return usersSnapshot.get('locale');
      } catch (error) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'locale': 'pt_BR'});
        return 'pt_BR';
      }
    } else
      throw 'Usuário não encontrado';
  }

  static Future<void> setCurrentUserLocale(String locale) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'locale': locale});
  }

  static Future<void> sendFriendshipRequest(AguinhaUser recipient) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('requestFriendship');
    await callable.call({'recipientID': recipient.uid});
  }

  static Future<void> acceptFriendshipRequest(AguinhaUser requester) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('acceptFriendRequest');
    await callable.call({'friendId': requester.uid});
  }

  static Future<void> denyFriendRequest(AguinhaUser requester) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('denyFriendRequest');
    await callable.call({'friendId': requester.uid});
  }

  static Future<void> notify(AguinhaUser friend, Drink drink) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('notify');
    await callable.call({'to': friend.uid, 'drink': API.drinkToAPI(drink)});
  }

  static Future<void> unfriend(AguinhaUser friend) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('unfriend');
    await callable.call({'uid': friend.uid});
  }

  static String drinkToAPI(Drink drink) {
    switch (drink) {
      case Drink.water:
        return 'WATER';
      case Drink.beer:
        return 'BEER';
      case Drink.coffee:
        return 'COFFEE';
      case Drink.juice:
        return 'JUICE';
      case Drink.wine:
        return 'WINE';
      case Drink.milk:
        return 'MILK';
      case Drink.tea:
        return 'TEA';
      default:
        return 'WATER';
    }
  }
}
