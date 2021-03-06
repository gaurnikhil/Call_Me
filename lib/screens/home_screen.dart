import 'package:call_me/provider/user_provider.dart';
import 'package:call_me/screens/call_screens/pickup/pickup_layout.dart';
import 'package:call_me/screens/page_views/chat_screen.dart';
import 'package:call_me/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;
  double _labelFontSize = 10.0;

  UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      userProvider.refreshUser();
    });

    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: [
            Container(
              child: ChatScreen(),
            ),
            Center(
              child: Text(
                'Call Log',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                'Contact Screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          onPageChanged: onPageChanged,
          controller: pageController,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: _page == 0
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                      fontSize: _labelFontSize,
                      color: _page == 0
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: _page == 1
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Logs",
                    style: TextStyle(
                      fontSize: _labelFontSize,
                      color: _page == 1
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: _page == 2
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                      fontSize: _labelFontSize,
                      color: _page == 2
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
