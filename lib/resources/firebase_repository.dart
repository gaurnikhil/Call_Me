import 'dart:io';

import 'package:call_me/model/message.dart';
import 'package:call_me/model/appUser.dart';
import 'package:call_me/provider/image_upload_provider.dart';
import 'package:call_me/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = new FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<AppUser> getUserDetails() => _firebaseMethods.getUserDetails();

  Future<User> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDB(User currentUser) =>
      _firebaseMethods.addDataToDB(currentUser);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<AppUser>> fetchAllUsers(User user) =>
      _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDB(
          Message message, AppUser sender, AppUser receiver) =>
      _firebaseMethods.addMessageToDB(message, sender, receiver);

  void uploadImage(
          {@required File image,
          @required String receiverId,
          @required String senderId,
          @required ImageUploadProvider imageUploadProvider}) =>
      _firebaseMethods.uploadImage(
          image, receiverId, senderId, imageUploadProvider);
}
