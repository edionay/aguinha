import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:aguinha/ui/drink_tile.dart';
import 'package:aguinha/ui/friend_tile.dart';
import 'package:aguinha/ui/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsSection extends StatefulWidget {
  const FriendsSection({Key? key}) : super(key: key);

  @override
  _FriendsSectionState createState() => _FriendsSectionState();
}

class _FriendsSectionState extends State<FriendsSection> {
  List<FriendTile> friendsWidgets = [];
  List<AguinhaUser> friends = [];
  bool notifying = false;
  Drink selectedDrink = Drink.water;
  String selectedEmoji = '💧';

  String getDailyNotificationID() {
    DateTime today = DateTime.now();
    return DateTime.utc(today.year, today.month, today.day, 0, 0, 0, 0)
        .millisecondsSinceEpoch
        .toString();
  }

  Future<void> notifyAll(List<AguinhaUser> friends) async {
    List<Future> notifications = [];
    for (var friend in friends) {
      notifications.add(API.notify(friend, selectedDrink));
    }
    await Future.wait(notifications);
  }

  String getEmoji(Drink drink) {
    switch (drink) {
      case Drink.water:
        return '💧';
      case Drink.beer:
        return '🍺';
      case Drink.coffee:
        return '☕';
      case Drink.juice:
        return '🧃';
      case Drink.wine:
        return '🍷';
      case Drink.milk:
        return '🥛';
      case Drink.tea:
        return '🍵';
      default:
        return '💧';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Center(
              child: TextButton(
                onPressed: notifying
                    ? null
                    : () async {
                        setState(() {
                          notifying = true;
                        });
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        final lastNotify = prefs.getInt('lastNotify') ??
                            DateTime.now().millisecondsSinceEpoch - 900000;

                        if (DateTime.now().millisecondsSinceEpoch - lastNotify <
                            300000) {
                          final snackBar = SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.notifyAgainAlert),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          try {
                            await notifyAll(friends);
                            final snackBar = SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .successfulNotifyAlert),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            await prefs.setInt('lastNotify',
                                DateTime.now().millisecondsSinceEpoch);
                          } catch (error) {
                            final snackBar = SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.unknownError),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                        setState(() {
                          notifying = false;
                        });
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TextButton(onPressed: () {}, child: Text('premium!')),
                    IconButton(
                        onPressed: () async {
                          final drink = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                color: kPrimaryColor,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: kDefaultPadding,
                                            right: kDefaultPadding,
                                            top: kDefaultPadding * 2,
                                            bottom: kDefaultPadding / 2),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .whatAreYouDrinking,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: kDefaultPadding,
                                            right: kDefaultPadding,
                                            bottom: kDefaultPadding * 2),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .drinkSelectionOption,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.water);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.water),
                                          drink: Drink.water,
                                          title: AppLocalizations.of(context)!
                                              .water,
                                          selected:
                                              selectedDrink == Drink.water,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.juice);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.juice),
                                          drink: Drink.juice,
                                          title: AppLocalizations.of(context)!
                                              .juice,
                                          selected:
                                              selectedDrink == Drink.juice,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.coffee);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.coffee),
                                          drink: Drink.coffee,
                                          title: AppLocalizations.of(context)!
                                              .coffee,
                                          selected:
                                              selectedDrink == Drink.coffee,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.tea);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.tea),
                                          drink: Drink.tea,
                                          title:
                                              AppLocalizations.of(context)!.tea,
                                          selected: selectedDrink == Drink.tea,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.wine);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.wine),
                                          drink: Drink.wine,
                                          title: AppLocalizations.of(context)!
                                              .wine,
                                          selected: selectedDrink == Drink.wine,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.milk);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.milk),
                                          drink: Drink.milk,
                                          title: AppLocalizations.of(context)!
                                              .milk,
                                          selected: selectedDrink == Drink.milk,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.beer);
                                        },
                                        child: DrinkTile(
                                          icon: getEmoji(Drink.beer),
                                          drink: Drink.beer,
                                          title: AppLocalizations.of(context)!
                                              .beer,
                                          selected: selectedDrink == Drink.beer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          print(drink);

                          if (drink != null) {
                            setState(() {
                              selectedEmoji = getEmoji(drink);
                              selectedDrink = drink;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_drop_down)),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Text(selectedEmoji,
                                style: TextStyle(fontSize: 30)))),
                    SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.notify,
                          style: TextStyle(
                              fontSize: 20,
                              color: notifying ? Colors.grey : kPrimaryColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!.everybody,
                          style: TextStyle(
                              fontSize: 20,
                              color: notifying ? Colors.grey : kPrimaryColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: kDefaultPadding * 2,
            ),
            SizedBox(
              height: kDefaultPadding * 2,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: kDefaultPadding * 2, bottom: kDefaultPadding / 2),
          child: Subtitle(title: AppLocalizations.of(context)!.friends),
        ),
        Container(
          height: 130,
          padding: EdgeInsets.only(left: kDefaultPadding * 2),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('friends')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              final friendsDocuments = snapshot.data!.docs;

              friendsWidgets = [];
              friends = [];
              for (var friend in friendsDocuments) {
                var aguinhaFriend = AguinhaUser(
                    friend.id, friend.get('nickname'), friend.get('suffix'));
                friendsDocuments.indexOf(friend);
                DateTime? lastSentNotification;
                DateTime? lastReceivedNotification;
                DateTime today = DateTime.now();
                String dailyNotificationID =
                    DateTime.utc(today.year, today.month, today.day, 0, 0, 0, 0)
                        .millisecondsSinceEpoch
                        .toString();

                try {
                  Timestamp timestamp = friend.get('lastSentNotification');
                  lastSentNotification = timestamp.toDate();
                } catch (error) {}
                try {
                  Timestamp timestamp = friend.get('lastReceivedNotification');
                  lastReceivedNotification = timestamp.toDate();
                } catch (error) {}
                friends.add(aguinhaFriend);
                friendsWidgets.add(
                  FriendTile(
                      friend: aguinhaFriend,
                      notifying: notifying,
                      selectedDrink: selectedDrink,
                      lastSentNotification: lastSentNotification,
                      lastReceivedNotification: lastReceivedNotification,
                      dailyNotificationID: dailyNotificationID),
                );
              }
              return GridView.count(
                // primary: true,
                shrinkWrap: true,
                // crossAxisSpacing: 20,
                // mainAxisSpacing: 20,
                childAspectRatio: 0.4,
                // physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                scrollDirection: Axis.horizontal,
                children: friendsWidgets,
              );
            },
          ),
        ),
      ],
    );
  }
}
