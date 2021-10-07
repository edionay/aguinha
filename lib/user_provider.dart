import 'package:aguinha/api.dart';
import 'package:aguinha/common.dart';

import 'aguinha_user.dart';

class UserProvider extends ChangeNotifier {
  AguinhaUser? _currentUser;
  AguinhaUser? get currentUser => _currentUser;
  String name = 'Edionay';

  void changeName() {
    name = 'edioney';
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      _currentUser = await API.getCurrentUser();
      notifyListeners();
    } catch (error) {
      print(error);
      notifyListeners();
      throw 'usuário não encontrado';
    }
  }
}
