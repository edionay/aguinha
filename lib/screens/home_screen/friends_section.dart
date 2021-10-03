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

  Future<void> notifyAll(List<AguinhaUser> friends) async {
    List<Future> notifications = [];
    for (var friend in friends) {
      notifications.add(API.notify(friend));
    }
    await Future.wait(notifications);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                          icon: Icons.local_drink,
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
                                          icon: Icons.local_drink,
                                          drink: Drink.juice,
                                          title: AppLocalizations.of(context)!
                                              .juice,
                                          selected:
                                              selectedDrink == Drink.juice,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.juice);
                                        },
                                        child: DrinkTile(
                                          icon: Icons.local_cafe,
                                          drink: Drink.juice,
                                          title: AppLocalizations.of(context)!
                                              .coffee,
                                          selected:
                                              selectedDrink == Drink.juice,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.tea);
                                        },
                                        child: DrinkTile(
                                          icon: Icons.emoji_food_beverage,
                                          drink: Drink.tea,
                                          title:
                                              AppLocalizations.of(context)!.tea,
                                          selected: selectedDrink == Drink.tea,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.tea);
                                        },
                                        child: DrinkTile(
                                          icon: Icons.wine_bar,
                                          drink: Drink.tea,
                                          title: AppLocalizations.of(context)!
                                              .wine,
                                          selected: selectedDrink == Drink.tea,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, Drink.tea);
                                        },
                                        child: DrinkTile(
                                          icon: Icons.sports_bar,
                                          drink: Drink.tea,
                                          title: AppLocalizations.of(context)!
                                              .beer,
                                          selected: selectedDrink == Drink.tea,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // if (drink != null) {
                          //   setState(() {
                          //     selectedDrink = drink;
                          //   });
                          // }
                        },
                        icon: Icon(Icons.arrow_drop_down)),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Icon(
                            Icons.local_drink,
                            size: 40,
                            color: notifying ? Colors.grey : kPrimaryColor,
                          ),
                        )),
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
                      lastSentNotification: lastSentNotification,
                      lastReceivedNotification: lastReceivedNotification),
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
