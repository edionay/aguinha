import 'dart:io';

import 'package:aguinha/aguinha_app_brain.dart';
import 'package:aguinha/payment_provider.dart';
import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/screens/error_screen.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:aguinha/screens/login_screen.dart';
import 'package:aguinha/screens/settings_screen.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:aguinha/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'api.dart';
import 'common.dart';
import 'components/premium/premium_screen.dart';

class AguinhaApp extends StatefulWidget {
  AguinhaApp({Key? key}) : super(key: key);

  @override
  _AguinhaAppState createState() => _AguinhaAppState();
}

class _AguinhaAppState extends State<AguinhaApp> {
  @override
  void initState() {
    AguinhaAppBrain.updateDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizations.delegate
        ],
        supportedLocales: [const Locale('en', ''), const Locale('pt', '')],
        theme: Theme.of(context).copyWith(
          textTheme: GoogleFonts.montserratTextTheme(),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
          ),
        ),
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
        },
      ),
    );
  }
}
