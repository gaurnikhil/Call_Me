import 'package:call_me/resources/call_methods.dart';
import 'package:call_me/screens/call_screens/call_screen.dart';
import 'package:call_me/screens/chatScreens/widgets/cached_image.dart';
import 'package:call_me/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:call_me/model/call.dart';

class PickupScreen extends StatelessWidget {
  final Call call;

  final CallMethods callMethods = CallMethods();

  PickupScreen({@required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            CachedImage(
              call.callerPic,
              isRound: true,
              height: 150.0,
              radius: 180,
              width: 150.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              call.callerName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.redAccent,
                  icon: Icon(
                    Icons.call_end,
                  ),
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  color: Colors.green,
                  icon: Icon(
                    Icons.call,
                  ),
                  onPressed: () async =>
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CallScreen(
                                    call: call,
                                    // role: ClientRole.Broadcaster,
                                  );
                                },
                              ),
                            )
                          : {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
