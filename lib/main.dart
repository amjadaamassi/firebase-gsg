import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_gsg/services/routes_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Auth/providers/auth_provider.dart';
import 'Auth/ui/auth_main_page.dart';
import 'Auth/ui/login_page.dart';
import 'Auth/ui/register_page.dart';
import 'Auth/ui/reset_password_page.dart';
import 'chats/home_page.dart';
import 'chats/profile_page.dart';
import 'chats/users_page.dart';
import 'splach_screen.dart';

void main() {
  runApp(ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: MaterialApp(
          routes: {
            LoginPage.routeName: (context) => LoginPage(),
            RegisterPage.routeName: (context) => RegisterPage(),
            ResetPasswordPage.routeName: (context) => ResetPasswordPage(),
            HomePage.routeName: (context) => HomePage(),
            AuthMainPage.routeName: (context) => AuthMainPage(),
            UsersPage.routeName: (context) => UsersPage(),
            ProfilePage.routeName: (context) => ProfilePage(),
          },
          navigatorKey: RouteHelper.routeHelper.navKey,
          home: FirebaseConfiguration())));
}

class FirebaseConfiguration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, AsyncSnapshot<FirebaseApp> dataSnapShot) {
          if (dataSnapShot.hasError) {
            return Scaffold(
              backgroundColor: Colors.red,
              body: Center(
                child: Text(dataSnapShot.error.toString()),
              ),
            );
          }
          if (dataSnapShot.connectionState == ConnectionState.done) {
            return SplachScreen();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
