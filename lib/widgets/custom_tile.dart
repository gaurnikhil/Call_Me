import 'package:call_me/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subTitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onPress;
  final GestureLongPressCallback onLongPress;

  CustomTile({
    @required this.leading,
    @required this.title,
    this.icon,
    @required this.subTitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.mini = true,
    this.onPress,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10.0 : 0.0),
        margin: margin,
        child: Row(
          children: [
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10.0 : 15.0),
                padding: EdgeInsets.symmetric(vertical: mini ? 3.0 : 20.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: UniversalVariables.separatorColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            icon ?? Container(),
                            subTitle,
                          ],
                        )
                      ],
                    ),
                    trailing ?? Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
