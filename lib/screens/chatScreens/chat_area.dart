import 'dart:io';
import 'package:call_me/enum/view_state.dart';
import 'package:call_me/model/message.dart';
import 'package:call_me/model/appUser.dart';
import 'package:call_me/provider/image_upload_provider.dart';
import 'package:call_me/resources/firebase_repository.dart';
import 'package:call_me/screens/chatScreens/widgets/cached_image.dart';
import 'package:call_me/utils/call_utilities.dart';
import 'package:call_me/utils/permissions.dart';
import 'package:call_me/utils/universal_variables.dart';
import 'package:call_me/utils/utilities.dart';
import 'package:call_me/widgets/custom_app_bar.dart';
import 'package:call_me/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatArea extends StatefulWidget {
  final AppUser receiver;

  ChatArea({this.receiver});

  @override
  _ChatAreaState createState() => _ChatAreaState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatAreaState extends State<ChatArea> {
  TextEditingController textFieldController = TextEditingController();

  bool isWriting = false;
  AppUser sender;
  String _currentUserId;

  ScrollController _listViewController = ScrollController();
  bool showEmojiPicker = false;
  FocusNode textFieldFocus = FocusNode();

  ImageUploadProvider _imageUploadProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      _repository.getCurrentUser().then((user) async {
        _currentUserId = user.uid;
        print(_currentUserId);

        setState(() {
          sender = AppUser(
            uid: user.uid,
            name: user.displayName,
            profilePhoto: user.photoURL,
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }

  showKeyboard() {
    textFieldFocus.requestFocus();
  }

  hideKeyboard() {
    textFieldFocus.unfocus();
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  margin: EdgeInsets.only(right: 15.0),
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
          showEmojiPicker ? emojiContainer() : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(sender.uid)
          .collection(widget.receiver.uid)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(10.0),
            reverse: true,
            controller: _listViewController,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.docs[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10.0);

    return Container(
      margin: EdgeInsets.only(top: 12.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    if (message.type == "image") {
      // print(message.photoUrl);
      return CachedImage(
        message.photoUrl,
        height: 250.0,
        width: 250.0,
        radius: 10.0,
      );
    }

    return Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10.0);

    return Container(
      margin: EdgeInsets.only(top: 12.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWriting(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        child: Icon(Icons.close),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and Tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      ModalTile(
                        onTap: () {
                          pickImage(source: ImageSource.gallery);
                        },
                        title: "Media",
                        subtitle: "Share photos and videos",
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab,
                      ),
                      ModalTile(
                        title: "Contact",
                        subtitle: "Share contacts",
                        icon: Icons.contacts,
                      ),
                      ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location,
                      ),
                      ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule,
                      ),
                      ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() {
      var text = textFieldController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        type: 'text',
        timestamp: Timestamp.now(),
      );

      setState(() {
        isWriting = false;
        textFieldController.clear();
      });

      print("emptying the string");
      textFieldController.text = "";
      print(textFieldController.text.length);

      _repository.addMessageToDB(_message, sender, widget.receiver);
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  onTap: () {
                    hideEmojiContainer();
                  },
                  focusNode: textFieldFocus,
                  controller: textFieldController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    (value.length > 0 && value.trim() != "")
                        ? setWriting(true)
                        : setWriting(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (showEmojiPicker) {
                      showKeyboard();
                      hideEmojiContainer();
                    } else {
                      hideKeyboard();
                      showEmojiContainer();
                    }
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.face,
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.record_voice_over,
                  ),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () {
                    hideEmojiContainer();
                    showKeyboard();
                    hideKeyboard();
                    pickImage(
                      source: ImageSource.camera,
                    );
                  },
                  child: Icon(
                    Icons.camera_alt,
                  ),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(
                    left: 10.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: UniversalVariables.fabGradient,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15.0,
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);

    FocusScope.of(context).requestFocus(new FocusNode());

    _repository.uploadImage(
      image: selectedImage,
      receiverId: widget.receiver.uid,
      senderId: _currentUserId,
      imageUploadProvider: _imageUploadProvider,
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text(
        widget.receiver.name,
      ),
      action: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(
                      from: sender, to: widget.receiver, context: context)
                  : {},
        ),
        IconButton(
            icon: Icon(
              Icons.phone,
            ),
            onPressed: () {}),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  ModalTile({this.title, this.subtitle, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: CustomTile(
        mini: false,
        onPress: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38.0,
          ),
        ),
        subTitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 13.0,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
