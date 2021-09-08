import 'package:aguinha/constants.dart';
import 'package:aguinha/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/large_background.svg',
            fit: BoxFit.fitHeight,
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
                        'bem-vindo ao',
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
                            'Entrar com o Google',
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
    );
  }
}
