import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/models/drink.dart';
import 'package:aguinha/services/api.dart';

class HomeBrain {
  static String getEmoji(Drink drink) {
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

  static Future<void> notifyAll(
      List<AguinhaUser> friends, Drink selectedDrink) async {
    List<Future> notifications = [];
    for (var friend in friends) {
      notifications.add(API.notify(friend, selectedDrink));
    }
    await Future.wait(notifications);
  }

  static String getDailyNotificationID() {
    DateTime today = DateTime.now();
    return DateTime.utc(today.year, today.month, today.day, 0, 0, 0, 0)
        .millisecondsSinceEpoch
        .toString();
  }
}
