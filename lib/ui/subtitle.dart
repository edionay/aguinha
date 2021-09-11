import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Color(0xFF005687), fontSize: 24.0),
    );
  }
}
