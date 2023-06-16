import 'package:flutter/cupertino.dart';
import 'package:my_application/services/database_service.dart';

class SignInNotifier with ChangeNotifier {
  bool isRegister = false;
  setIsRegister() {
    isRegister = isRegister ? false : true;
    notifyListeners();
  }

  resetScreen() {
    notifyListeners();
  }

  signUp(user) async {
    final DatabaseService _databaseService = DatabaseService();
    await _databaseService.create();
    await _databaseService.insertUser(user);
  }

  getUsers() async {
    final DatabaseService _databaseService = DatabaseService();
    final List<dynamic> maps = await _databaseService.users();
    return maps;
  }
}
