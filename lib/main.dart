import 'dart:async';
import 'dart:io';

import 'package:aguinha/ad_state.dart';
import 'package:aguinha/payment_provider.dart';
import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/screens/error_screen.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:aguinha/screens/login_screen.dart';
import 'package:aguinha/screens/onboarding_screen.dart';
import 'package:aguinha/screens/premium_screen.dart';
import 'package:aguinha/screens/settings_screen.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'api.dart';
import 'common.dart';
import 'package:uni_links/uni_links.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:flutter/services.dart' show PlatformException;

const bool USE_EMULATOR = false;

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
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

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

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  runApp(Provider.value(
      value: adState, builder: (context, child) => AguinhaApp()));
}

class AguinhaApp extends StatefulWidget {
  AguinhaApp({Key? key}) : super(key: key);

  @override
  _AguinhaAppState createState() => _AguinhaAppState();
}

class _AguinhaAppState extends State<AguinhaApp> {
  Future<void> initUniLinks() async {
    // Uri parsing may fail, so we use a try/catch FormatException.
    try {
      final initialUri = await getInitialUri();
      print(initialUri);
      // Use the uri and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on FormatException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
    // ... other exception handling like PlatformException
  }

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
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

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      print('listinha');
      print(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    initUniLinks();
    super.initState();
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
          HomeScreen.id: (context) => HomeScreen(),
          AddUserScreen.id: (context) => AddUserScreen(),
          UsernameScreen.id: (context) => UsernameScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          PremiumScreen.id: (context) => PremiumScreen(),
          '/u/*': (context) => AddUserScreen(
                username: 'EDIONAY#4544',
              )
        },
      ),
    );
  }
}
