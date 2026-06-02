import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../repositories/task_repository.dart';

class AuthController with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  User? _currentUser;
  
  User? get currentUser => _currentUser;

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final user = await _repository.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final user = await _repository.loginUser(email, password);
    if (user != null) {
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    final user = User(name: name, email: email, password: password);
    bool success = await _repository.registerUser(user);
    if (success) {
      return await login(email, password);
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }
}
