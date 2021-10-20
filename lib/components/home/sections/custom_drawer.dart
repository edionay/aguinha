import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/components/friends_requests/friends_requests_screen.dart';
import 'package:aguinha/components/premium/premium_screen.dart';
import 'package:aguinha/components/tutorial/tutorial_screen.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/providers/provider.dart';
import 'package:aguinha/components/add_friend/add_friend_screen.dart';
import 'package:aguinha/components/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AguinhaUser? currentUser;

  @override
  void initState() {
    API.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    super.initState();
  }

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

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Column(
              children: [],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text(AppLocalizations.of(context)!.addFriend),
            onTap: () {
              Navigator.popAndPushNamed(context, AddUserScreen.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text(AppLocalizations.of(context)!.friendsRequests),
            onTap: () {
              Navigator.popAndPushNamed(context, FriendsRequestsScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.verified),
            title: Text('Premium'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PremiumScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text(AppLocalizations.of(context)!.support),
            onTap: () {
              launchURL();
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(AppLocalizations.of(context)!.howToUse),
            onTap: () {
              if (currentUser != null)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TutorialScreen(currentUser!.username)),
                );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.popAndPushNamed(context, SettingsScreen.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
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
      ),
    );
  }
}
