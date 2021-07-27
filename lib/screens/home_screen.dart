import 'package:aguinha/screens/error_screen.dart';
import 'package:aguinha/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xff2bd3ff), Color(0xff015afb)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Aguinha',
                      style: new TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Color(0xFF0052F1),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'FAMINTE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: Color(0xFF0016DA),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'AZUKI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: Color(0xFF020E7B),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'DINO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError)
            return ErrorScreen();
          else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
