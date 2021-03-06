import 'package:call_me/provider/image_upload_provider.dart';
import 'package:call_me/provider/user_provider.dart';
import 'package:call_me/resources/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/page_views/searchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = new FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageUploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        title: 'Call Me',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: _repository.getCurrentUser(),
            builder: (context, AsyncSnapshot<User> snapShot) {
              if (snapShot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
