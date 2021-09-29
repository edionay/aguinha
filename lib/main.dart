import 'dart:io';

import 'package:aguinha/ad_state.dart';
import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/screens/error_screen.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:aguinha/screens/login_screen.dart';
import 'package:aguinha/screens/settings_screen.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'api.dart';
import 'common.dart';

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
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

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

  runApp(Provider.value(
      value: adState, builder: (context, child) => AguinhaApp()));
}

class AguinhaApp extends StatefulWidget {
  AguinhaApp({Key? key}) : super(key: key);

  @override
  _AguinhaAppState createState() => _AguinhaAppState();
}

class _AguinhaAppState extends State<AguinhaApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('cliquei agora');

      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });

    API.getCurrentUser().then((currentUser) {
      print('updating token');
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

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizations.delegate
        ],
        supportedLocales: [const Locale('en', ''), const Locale('pt', '')],
        theme: Theme.of(context)
            .copyWith(textTheme: GoogleFonts.montserratTextTheme()),
        home: Scaffold(
          body: StreamBuilder(
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
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          FriendsScreen.id: (context) => FriendsScreen(),
          AddUserScreen.id: (context) => AddUserScreen(),
          UsernameScreen.id: (context) => UsernameScreen(),
          SettingsScreen.id: (context) => SettingsScreen()
        },
      ),
    );
  }
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
