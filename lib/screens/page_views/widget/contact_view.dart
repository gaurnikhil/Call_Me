import 'package:call_me/utils/universal_variables.dart';
import 'package:call_me/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomTile(
      mini: false,
      onPress: () {},
      title: Text(
        "Its Me",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subTitle: Text(
        "Hello",
        style: TextStyle(
          color: UniversalVariables.greyColor,
          fontSize: 14,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  "https://lh3.googleusercontent.com/a-/AOh14GhqDOXXGob-HfxLm_MvVsQmMWrYAwvbZgW74sqb00o=s96-c"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UniversalVariables.onlineDotColor,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
