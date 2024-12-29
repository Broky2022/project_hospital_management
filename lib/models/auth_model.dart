import 'package:flutter/foundation.dart';

class AuthModel extends ChangeNotifier {
bool _isLoggedIn = false;
bool _isLoading = false;

bool get isLoggedIn => _isLoggedIn;
bool get isLoading => _isLoading;

void setLoading(bool value) {
  _isLoading = value;
  notifyListeners();
}

void loginSuccess() {
  _isLoggedIn = true;
  notifyListeners();
}

void logout() {
  _isLoggedIn = false;
  notifyListeners();
}
}
