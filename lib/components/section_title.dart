import 'package:aguinha/constants.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: kDefaultPadding * 3,
        ),
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Text(
            title,
            style: kSubheaderStyle,
          ),
        ),
        SizedBox(
          height: kDefaultPadding / 2,
        ),
      ],
    );
  }
}
