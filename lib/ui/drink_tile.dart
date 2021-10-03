import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/home_screen.dart';

class DrinkTile extends StatelessWidget {
  const DrinkTile(
      {required this.drink,
      required this.title,
      required this.selected,
      required this.icon});

  final Drink drink;
  final bool selected;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: selected ? Colors.white : kPrimaryColor,
          borderRadius: BorderRadius.circular(40)),
      margin: EdgeInsets.only(
          bottom: kDefaultPadding * 2,
          left: kDefaultPadding * 2,
          right: kDefaultPadding * 2),
      child: ListTile(
        enabled: false,
        leading: CircleAvatar(
          child: Icon(
            icon,
            color: selected ? Colors.white : kPrimaryColor,
          ),
          backgroundColor: selected ? kPrimaryColor : Colors.white,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (drink != Drink.water)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                decoration: BoxDecoration(
                    color: selected ? kPrimaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  AppLocalizations.of(context)!.soon,
                  style: TextStyle(
                      color: selected ? Colors.white : kPrimaryColor,
                      fontSize: 10),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(color: selected ? kPrimaryColor : Colors.white),
        ),
        onTap: () {},
      ),
    );
  }
}
