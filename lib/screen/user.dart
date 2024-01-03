import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/auth/login.dart';
import 'package:tubes_ppb/component/change_profile.dart';
import 'package:tubes_ppb/component/edit_profile.dart';
import 'package:tubes_ppb/component/image_profile.dart';
import 'package:tubes_ppb/style/color.dart';

// ignore: must_be_immutable
class User extends StatelessWidget {
  User({super.key});
  final GlobalKey<ImageProfileState> childKey = GlobalKey<ImageProfileState>();

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final auth = FirebaseAuth.instance;
  var data;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              color: red,
              child: StreamBuilder(
                stream: db.collection("userData").doc(uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  data = snapshot.data!.data();
                  print(data);
                  return Row(
                    children: [
                      ImageProfile(key: childKey, path: "profile_image/$uid"),
                      ChangeProfile(childKey: childKey),
                      Text(data?['username'] ?? 'error')
                    ],
                  );
                },
              )),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfile(data: data,),
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  color: blue,
                  height: 70,
                  child: const Row(
                    children: [
                      FaIcon(FontAwesomeIcons.user),
                      Text("Edit profile")
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                color: blue,
                height: 70,
                child: const Row(
                  children: [FaIcon(FontAwesomeIcons.gear), Text("Settings")],
                ),
              ),
              InkWell(
                onTap: () {
                  auth.signOut();
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Login(),
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  color: blue,
                  height: 70,
                  child: const Row(
                    children: [
                      FaIcon(FontAwesomeIcons.rightFromBracket),
                      Text("Logout")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
