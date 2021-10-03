import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bottom_menu_button.dart';

class BottomMenuSection extends StatelessWidget {
  const BottomMenuSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void launchURL() async {
      final _url =
          'mailto:aguinha@edionay.com?subject=${AppLocalizations.of(context)!.supportMailTitle}&body=';
      try {
        await canLaunch(_url)
            ? await launch(_url)
            : throw 'Could not launch $_url';
      } catch (error) {
        print(error);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BottomMenuButton(
          icon: Icons.person_add,
          label: AppLocalizations.of(context)!.addFriend,
          onPress: () {
            Navigator.pushNamed(context, AddUserScreen.id);
          },
        ),
        BottomMenuButton(
          icon: Icons.group,
          label: AppLocalizations.of(context)!.friendsRequests,
          onPress: () {
            Navigator.pushNamed(context, FriendsScreen.id);
          },
        ),
        BottomMenuButton(
          icon: Icons.feedback,
          label: AppLocalizations.of(context)!.support,
          onPress: () {
            // launchURL();
            Navigator.pushNamed(context, SettingsScreen.id);
          },
        ),
        BottomMenuButton(
          icon: Icons.logout,
          label: AppLocalizations.of(context)!.logout,
          onPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider
                    .logout()
                    .then((value) => Navigator.pop(context))
                    .catchError((error) {
                  Navigator.pop(context);
                  final snackBar = SnackBar(content: Text(error.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
                return Container(
                  height: 100,
                  color: kPrimaryColor,
                  child: Center(
                      child: Text(
                    'saindo...',
                    style: TextStyle(color: Colors.white),
                  )),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
