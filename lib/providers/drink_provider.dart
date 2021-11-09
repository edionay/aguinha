import 'package:aguinha/models/drink.dart';
import 'package:aguinha/shared/common.dart';

class DrinkProvider with ChangeNotifier {
  Drink _selectedDrink = Drink.water;
  Drink get selectedDrink => _selectedDrink;

  void setDrink(Drink drink) {
    _selectedDrink = drink;
    notifyListeners();
  }
}
