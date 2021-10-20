import 'package:aguinha/shared/common.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({required this.title, this.hint});

  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Color(0xFF005687), fontSize: 24.0),
        ),
        SizedBox(
          height: kDefaultPadding / 3,
        ),
        if (hint != null)
          Text(
            hint!,
            style:
                TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w100),
          ),
      ],
    );
  }
}
