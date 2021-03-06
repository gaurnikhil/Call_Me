import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:call_me/model/appUser.dart';
import 'package:call_me/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  AppUser _appUser;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  AppUser get getUser => _appUser;

  void refreshUser() async {
    AppUser appUser = await _firebaseRepository.getUserDetails();
    _appUser = appUser;
    notifyListeners();
  }
}
