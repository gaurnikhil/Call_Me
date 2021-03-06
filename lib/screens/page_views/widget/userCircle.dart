import 'package:call_me/provider/user_provider.dart';
import 'package:call_me/utils/universal_variables.dart';
import 'package:call_me/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        color: UniversalVariables.separatorColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              Utils.getInitials(userProvider.getUser.name),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                color: UniversalVariables.onlineDotColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: UniversalVariables.blackColor,
                  width: 2.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
