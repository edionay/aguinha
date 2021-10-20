import 'package:aguinha/aguinha_brain.dart';
import 'package:aguinha/components/friends_requests/friends_requests_screen.dart';
import 'package:aguinha/providers/payment_provider.dart';
import 'package:aguinha/providers/provider.dart';
import 'package:aguinha/components/add_friend/add_friend_screen.dart';
import 'package:aguinha/components/error_screen.dart';
import 'package:aguinha/components/home/home_screen.dart';
import 'package:aguinha/components/login/login_screen.dart';
import 'package:aguinha/components/settings/settings_screen.dart';
import 'package:aguinha/components/username/username_screen.dart';
import 'package:aguinha/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'shared/common.dart';
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
          FriendsRequestsScreen.id: (context) => FriendsRequestsScreen(),
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
