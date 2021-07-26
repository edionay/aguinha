import 'package:flutter/material.dart';

void main() {
  runApp(YoWaterApp());
}

class YoWaterApp extends StatelessWidget {
  const YoWaterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SafeArea(child: YosScreen()));
  }
}

class YosScreen extends StatelessWidget {
  const YosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        children: [
          Container(
            color: Color(0xFF000C66),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'JOAO',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Color(0xFF122620),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'NATALHA',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Color(0xFF274472),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'DAVID',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Color(0xFFB68D40),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'MATHEUS',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
