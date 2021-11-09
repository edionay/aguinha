import 'package:aguinha/components/home/home_brain.dart';
import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/models/drink.dart';
import 'package:aguinha/providers/drink_provider.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/components/premium/premium_screen.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/providers/payment_provider.dart';
import 'package:aguinha/components/home/ui/drink_tile.dart';
import 'package:aguinha/shared/ui/friend_tile.dart';
import 'package:aguinha/shared/ui/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/src/provider.dart';
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
  String selectedEmoji = '💧';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Drink selectedDrink =
        Provider.of<DrinkProvider>(context, listen: false).selectedDrink;

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
                            await HomeBrain.notifyAll(friends, selectedDrink);
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
                          final Drink drink = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              bool isPremium =
                                  context.watch<PaymentProvider>().isPremium;

                              drinkSelectionAction(Drink drink) {
                                if (isPremium || drink == Drink.water) {
                                  Navigator.pop(context, drink);
                                } else {
                                  Navigator.pushNamed(
                                      context, PremiumScreen.id);
                                }
                              }

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
                                          drinkSelectionAction(Drink.water);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon: HomeBrain.getEmoji(Drink.water),
                                          drink: Drink.water,
                                          title: AppLocalizations.of(context)!
                                              .water,
                                          selected:
                                              selectedDrink == Drink.water,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          drinkSelectionAction(Drink.juice);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon: HomeBrain.getEmoji(Drink.juice),
                                          drink: Drink.juice,
                                          title: AppLocalizations.of(context)!
                                              .juice,
                                          selected:
                                              selectedDrink == Drink.juice,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          drinkSelectionAction(Drink.coffee);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon:
                                              HomeBrain.getEmoji(Drink.coffee),
                                          drink: Drink.coffee,
                                          title: AppLocalizations.of(context)!
                                              .coffee,
                                          selected:
                                              selectedDrink == Drink.coffee,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          drinkSelectionAction(Drink.tea);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon: HomeBrain.getEmoji(Drink.tea),
                                          drink: Drink.tea,
                                          title:
                                              AppLocalizations.of(context)!.tea,
                                          selected: selectedDrink == Drink.tea,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          drinkSelectionAction(Drink.wine);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon: HomeBrain.getEmoji(Drink.wine),
                                          drink: Drink.wine,
                                          title: AppLocalizations.of(context)!
                                              .wine,
                                          selected: selectedDrink == Drink.wine,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          drinkSelectionAction(Drink.milk);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon: HomeBrain.getEmoji(Drink.milk),
                                          drink: Drink.milk,
                                          title: AppLocalizations.of(context)!
                                              .milk,
                                          selected: selectedDrink == Drink.milk,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          drinkSelectionAction(Drink.beer);
                                        },
                                        child: DrinkTile(
                                          premium: isPremium,
                                          icon: HomeBrain.getEmoji(Drink.beer),
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

                          if (drink != null) {
                            Provider.of<DrinkProvider>(context, listen: false)
                                .setDrink(drink);
                            setState(() {
                              selectedEmoji = HomeBrain.getEmoji(drink);
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
                String dailyNotificationID = HomeBrain.getDailyNotificationID();

                try {
                  lastSentNotification = DateTime.fromMillisecondsSinceEpoch(
                      friend.get('lastSentNotification'));
                } catch (error) {}
                try {
                  lastReceivedNotification =
                      DateTime.fromMillisecondsSinceEpoch(
                          friend.get('lastReceivedNotification'));
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
                shrinkWrap: true,
                childAspectRatio: 0.4,
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
