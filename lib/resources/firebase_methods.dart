import 'dart:io';
import 'package:call_me/provider/image_upload_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:call_me/model/message.dart';
import 'package:call_me/model/appUser.dart';
import 'package:call_me/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection =
      fireStore.collection("user");

  static final CollectionReference _messageCollection =
      fireStore.collection("messages");

  AppUser user = AppUser();

  Reference _storageReference;

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<AppUser> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return AppUser.fromMap(documentSnapshot.data());
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    User user = userCredential.user;

    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await fireStore
        .collection("user")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDB(User currentUser) async {
    String userName = Utils.getUserName(currentUser.email);

    user = AppUser(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: userName,
    );

    await fireStore
        .collection("user")
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  Future<void> signOut() async {
    _googleSignIn.disconnect();
    _googleSignIn.signOut();

    return await _auth.signOut();
  }

  Future<List<AppUser>> fetchAllUsers(User currentUser) async {
    List<AppUser> userList = List<AppUser>();

    print("fetching");

    QuerySnapshot querySnapshot = await fireStore.collection("user").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(
          AppUser.fromMap(querySnapshot.docs[i].data()),
        );
      }
    }

    bool empty = userList.isEmpty ? true : false;

    // print(empty);
    // for (var i = 0; i < userList.length; i++) {
    //   print(userList[i].name);
    // }

    return userList;
  }

  Future<void> addMessageToDB(
      Message message, AppUser sender, AppUser receiver) async {
    var map = message.toMap();

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().microsecondsSinceEpoch}');

      UploadTask _storageUploadTask = _storageReference.putFile(image);

      var url;

      await _storageUploadTask.whenComplete(
        () async {
          url = await _storageReference.getDownloadURL();
        },
      );

      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImageMessage(String url, String receiverId, String senderId) async {
    Message _message = Message.imageMessage(
      senderId: senderId,
      receiverId: receiverId,
      timestamp: Timestamp.now(),
      type: 'image',
      photoUrl: url,
      message: "IMAGE",
    );

    var map = _message.toImageMap();

    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverID, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    print(url);

    imageUploadProvider.setToIdle();

    setImageMessage(url, receiverID, senderId);
  }
}
