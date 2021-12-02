import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFriendsPage extends StatelessWidget {
  const AddFriendsPage({
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
              'assets/snail.svg',
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
                  padding: const EdgeInsets.all(kDefaultPadding * 2),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.addFriends,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                      text:
                          '${AppLocalizations.of(context)!.askYourFriendsForTheirUsername}',
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.tap,
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                            text:
                                ' ${AppLocalizations.of(context)!.addFriend} ',
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: AppLocalizations.of(context)!.typeTheirUsername,
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
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
                        text: AppLocalizations.of(context)!.afterInviteSent,
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                              text:
                                  ' ${AppLocalizations.of(context)!.friendsRequests}',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
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
