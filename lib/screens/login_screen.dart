import 'package:aguinha/constants.dart';
import 'package:aguinha/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:aguinha/common.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        color: kPrimaryColor,
        child: Stack(
          children: [
            Container(
              child: SvgPicture.asset(
                'assets/main_background.svg',
                excludeFromSemantics: true,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding * 2, left: kDefaultPadding * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.welcomeTo,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          'aguinha',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        await provider.googleLogin(context);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: FittedBox(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/google_icon.svg',
                            ),
                            SizedBox(
                              width: kDefaultPadding,
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.signInWith} Google',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
