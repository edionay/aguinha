import 'package:aguinha/components/home/home_screen.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/components/tutorial/sections/add_friends_page.dart';
import 'package:aguinha/components/tutorial/sections/notify_friends_page.dart';
import 'package:aguinha/components/tutorial/sections/username_page.dart';
import 'package:introduction_screen/introduction_screen.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen(this.username);
  final username;

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      controlsPadding: EdgeInsets.zero,
      rawPages: [
        UsernamePage(username: username),
        AddFriendsPage(),
        NotifyFriendsPage(),
      ],
      onDone: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
      },
      onSkip: () {},
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
