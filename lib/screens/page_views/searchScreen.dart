import 'package:call_me/model/appUser.dart';
import 'package:call_me/resources/firebase_repository.dart';
import 'package:call_me/screens/chatScreens/chat_area.dart';
import 'package:call_me/utils/universal_variables.dart';
import 'package:call_me/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseRepository _repository = FirebaseRepository();

  List<AppUser> usersList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getCurrentUser().then((user) {
      _repository.fetchAllUsers(user).then((List<AppUser> list) {
        setState(() {
          usersList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    // print("At the app Bar");
    return GradientAppBar(
      gradient: LinearGradient(colors: [
        UniversalVariables.gradientColorStart,
        UniversalVariables.gradientColorEnd
      ]),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            autofocus: true,
            cursorColor: UniversalVariables.blackColor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25.0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  searchController.clear();
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0x88ffffff),
                fontSize: 35.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    // print("Matching");
    // print(query);
    List<AppUser> suggestionList = query.isEmpty
        ? []
        : usersList.where((AppUser user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);
            // print(_query);
            // print(_getName);
            // print(_getUsername);
            return (matchesUsername || matchesName);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        print(suggestionList[index].uid);
        AppUser searchedUser = AppUser(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );

        return CustomTile(
          mini: false,
          onPress: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatArea(
                receiver: searchedUser,
              );
            }));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subTitle: Text(
            searchedUser.name,
            style: TextStyle(
              color: UniversalVariables.greyColor,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: buildSuggestions(query),
      ),
    );
  }
}
