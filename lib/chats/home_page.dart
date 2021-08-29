import 'package:firebase_gsg/chats/users_page.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';



class HomePage extends StatelessWidget {
  static final routeName = 'home';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child:
            Scaffold(body: TabBarView(children: [UsersPage(), ProfilePage()])));
  }
}
