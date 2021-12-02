import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UsernamePage extends StatelessWidget {
  const UsernamePage({
    Key? key,
    required this.username,
  });

  final username;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Container(
      color: kPrimaryColor,
      child: Column(
        children: [
          Container(
            height: _size.height * 0.4,
            child: SvgPicture.asset(
              'assets/turtle.svg',
              width: 100,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * 2),
                  child: Text(
                    AppLocalizations.of(context)!.username,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                      text: '${AppLocalizations.of(context)!.usernameSet} ',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.w300),
                      children: [
                        TextSpan(
                            text: username,
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!
                          .shareYourCompleteUsername,
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
