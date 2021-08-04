import 'dart:io';

import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/error_screen.dart';
import 'package:aguinha/screens/friends_screen/friends_screen.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:aguinha/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

const bool USE_EMULATOR = true;

Future _connectToFirebaseEmulator() async {
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  // FirebaseFirestore.instance.useFirestoreEmulator('$localHostString', 8080);
  FirebaseFunctions.instance.useFunctionsEmulator('$localHostString', 5001);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
  print(message);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (USE_EMULATOR) {
    _connectToFirebaseEmulator();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(AguinhaApp());
}

class AguinhaApp extends StatelessWidget {
  AguinhaApp({Key? key}) : super(key: key);

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff2bd3ff), Color(0xff015afb)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: Theme.of(context)
              .copyWith(textTheme: GoogleFonts.montserratTextTheme()),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return HomeScreen();
              } else if (snapshot.hasError)
                return ErrorScreen();
              else {
                return LoginScreen();
              }
            },
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            FriendsScreen.id: (context) => FriendsScreen(),
          },
        ),
      );
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification!;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         print(notification.title);
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       RemoteNotification notification = message.notification!;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         showDialog(
//             context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text(notification.title!),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [Text(notification.body!)],
//                   ),
//                 ),
//               );
//             });
//       }
//     });
//     FirebaseMessaging.instance.getToken().then((value) => print(value));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Shader linearGradient = LinearGradient(
//       colors: <Color>[Color(0xff2bd3ff), Color(0xff015afb)],
//     ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'Aguinha',
//                   style: new TextStyle(
//                       fontSize: 60.0,
//                       fontWeight: FontWeight.bold,
//                       foreground: Paint()..shader = linearGradient),
//                 ),
//               ),
//             ),
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(80),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     color: Color(0xFF0052F1),
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: 30),
//                     child: Text(
//                       'FAMINTE',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     color: Color(0xFF0016DA),
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: 30),
//                     child: Text(
//                       'AZUKI',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     color: Color(0xFF020E7B),
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: 30),
//                     child: Text(
//                       'DINO',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
