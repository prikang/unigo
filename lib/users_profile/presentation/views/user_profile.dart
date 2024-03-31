import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unigo/core/api.dart';
import 'package:unigo/users_profile/presentation/views/rider_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/login/views/main_login_screen.dart';
import '../../../utils/custom_navigation/app_nav.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHelloState();
}

class _MyHelloState extends ConsumerState<UserProfile> {
  
String token = "";
var parsedToken = 0;

List<Map<String, dynamic>> userlist = [];
List<Map<String, dynamic>>? matchingUsers;
  @override
  void initState() {
    Api.getInfo().then((value) {
      if (value != null && value is List<Map<String, dynamic>>) {
        setState(() {
          userlist = value;
        });
      }
    });
    super.initState();
  }
  String? match;
String? name;

  @override
  Widget build(BuildContext context) {
    int index=0;
    int index1 = index < (matchingUsers?.length ?? 0)  ? index :0;
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        automaticallyImplyLeading: false,
        actions: [
           
            IconButton(
              icon: const Icon(CupertinoIcons.person_circle_fill),
              color: CupertinoColors.systemGrey4,
              iconSize: 9.w,
              onPressed: () {
               normalNav(context, RiderProfile());
              },
            )
          ],
      ),
      body: userlist.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userlist.length,
              itemBuilder: (context, index) {
                final user = userlist[index];
                return ListTile(
                  title: Text('Username: ${user['username']}'),
                  subtitle: Text('Email: ${user['email']}'),
                  
                );
              },
            ),
    );
  }
}
