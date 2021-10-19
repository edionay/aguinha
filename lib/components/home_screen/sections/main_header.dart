import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:aguinha/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: _size.height * 0.4,
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: SvgPicture.asset(
                'assets/main_background.svg',
                excludeFromSemantics: true,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomLeft,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: kDefaultPadding * 2, top: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'aguinha',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    FutureBuilder(
                        future: API.getCurrentUser(),
                        builder:
                            (context, AsyncSnapshot<AguinhaUser> snapshot) {
                          if (snapshot.hasData) {
                            final currentUser = snapshot.data;
                            return Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Consumer<UserProvider>(
                                    //     builder: (_, test, child) {
                                    //   return Text(test.currentUser!.username);
                                    // }),
                                    Text(
                                      currentUser!.nickname,
                                      style: TextStyle(
                                          color: Color(0xFF7FBFE5),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '#${currentUser.suffix}',
                                      style: TextStyle(
                                          color: Color(0xFFB0D9EF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                    semanticLabel: AppLocalizations.of(context)!
                                        .copyUsername,
                                  ),
                                  onPressed: () async {
                                    try {
                                      Clipboard.setData(ClipboardData(
                                          text: currentUser.username));
                                      final snackBar = SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .usernameCopied),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } catch (error) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .unknownError),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                )
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UsernameScreen()),
                                (route) => false);
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    bottom: kDefaultPadding,
                    right: kDefaultPadding,
                    child: Text(
                      '${AppLocalizations.of(context)!.version} ${snapshot.data!.version}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        SvgPicture.asset(
          'assets/nav_background.svg',
          excludeFromSemantics: true,
          colorBlendMode: BlendMode.clear,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ],
    );
  }
}
