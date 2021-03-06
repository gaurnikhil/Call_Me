import 'package:call_me/resources/firebase_repository.dart';
import 'package:call_me/screens/page_views/widget/new_chat_button.dart';
import 'package:call_me/screens/page_views/widget/userCircle.dart';
import 'package:call_me/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:call_me/widgets/custom_app_bar.dart';
import 'package:call_me/utils/utilities.dart';
import 'package:call_me/widgets/custom_tile.dart';

class ChatScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      title: UserCircle(),
      action: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
          ),
          onPressed: () {},
        )
      ],
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: 2,
        itemBuilder: (context, index) {},
      ),
    );
  }
}
