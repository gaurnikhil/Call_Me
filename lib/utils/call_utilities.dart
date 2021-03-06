import 'dart:math';
import 'package:flutter/material.dart';
import 'package:call_me/model/appUser.dart';
import 'package:call_me/model/call.dart';
import 'package:call_me/resources/call_methods.dart';
import 'package:call_me/screens/call_screens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({AppUser from, AppUser to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
              call: call,
              // role: ClientRole.Broadcaster,
            ),
          ));
    } else {
      print("unsucessful");
    }
  }
}
