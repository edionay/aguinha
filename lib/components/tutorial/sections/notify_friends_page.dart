import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifyFriendsPage extends StatelessWidget {
  const NotifyFriendsPage({
    Key? key,
  }) : super(key: key);

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
              'assets/lobster.svg',
              width: 100,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(kDefaultPadding * 2),
                  child: Text(
                    AppLocalizations.of(context)!.tellYourFriendsYoureDrinking,
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
                        text: AppLocalizations.of(context)!.tap,
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.local_drink,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' ${AppLocalizations.of(context)!.notify} ${AppLocalizations.of(context)!.everybody}',
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!
                                .toNotifyYourFriends,
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.afterThat,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                        text: AppLocalizations.of(context)!.optionsLocation,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                        children: [
                          TextSpan(
                            text: ' ${AppLocalizations.of(context)!.menu} ',
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' ${AppLocalizations.of(context)!.section} ',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 16),
                          ),
                        ]),
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
