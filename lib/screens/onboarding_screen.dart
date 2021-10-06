import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen(this.username);
  final username;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return IntroductionScreen(
      controlsPadding: EdgeInsets.zero,
      rawPages: [
        Container(
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
                        'nome de usuário',
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
                          text: 'seu nome de usuário ficou definido como ',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w300),
                          children: [
                            TextSpan(
                                text: ' $username ',
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
                          text:
                              'compartilhe este nome completo (com # e número) com seus amigos para que eles possam adicionar você',
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
        ),
        Container(
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
                          'adicione amigos',
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
                          text: 'peça o nome de usuário para seus amigos',
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
                              text: "toque em ",
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
                                text: ' adicionar amigo ',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  "para adicionar alguém e insira o nome de usuário",
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
                            text:
                                'após enviar um convite, seu amigo deve aceitar o pedido tocando em ',
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
                                  text: 'solicitações de amizade',
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
        ),
        Container(
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
                        'avise seus amigos que tomou água!',
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
                            text: 'toque em ',
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
                                text: 'notificar todos',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' para avisar seus amigos',
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
                          text:
                              'após isso, todos eles receberão uma notificação informando que você tomou água',
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
                            text:
                                'as opções mencionadas anteriormente podem ser encontradas no botão ',
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                            children: [
                              TextSpan(
                                text: 'MENU',
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
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      onDone: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
        // When done button is press
      },
      onSkip: () {
        // You can also override onSkip callback
      },
      showSkipButton: false,
      skip: Icon(Icons.skip_next),
      next: Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: Text("Entendi",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      dotsContainerDecorator: BoxDecoration(
          // color: Colors.pink,
          ),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          activeColor: Colors.white,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}

class OnboardingPageModel extends StatelessWidget {
  const OnboardingPageModel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomLeft,
        children: [
          SvgPicture.asset(
            'assets/animals.svg',
            color: Color(0xFF054675).withOpacity(0.15),
            alignment: Alignment.bottomRight,
            fit: BoxFit.fill,
            // fit: BoxFit.fitHeight,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/whale_icon.svg',
                  // color: kPrimaryColor,
                  width: 100,
                  alignment: Alignment.center,
                  // fit: BoxFit.fitHeight,
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * 2),
                  child: Text(
                    title,
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
                      text: 'seu nome de usuário ficou definido como ',
                      style: TextStyle(fontSize: 16),
                      // style: DefaultTextStyle.of(context).style,
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'EDIONAY#4544',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  child: Text(
                    'compartilhe este nome completo (com # e número) com seus amigos para que eles possam adicionar você',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
