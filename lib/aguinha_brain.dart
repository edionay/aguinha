import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'services/api.dart';

class AguinhaAppBrain {
  static void updateDeviceToken() {
    API.getCurrentUser().then((currentUser) {
      FirebaseMessaging.instance.getToken().then((fmcToken) {
        final ref = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('tokens')
            .doc(fmcToken);
        ref.set({
          'token': fmcToken,
          'created': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem
        });
      });
    });
  }
}
