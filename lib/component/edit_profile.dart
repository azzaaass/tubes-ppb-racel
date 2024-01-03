import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/style/color.dart';

class EditProfile extends StatelessWidget {
  final Map<String, dynamic> data;
  EditProfile({super.key, required this.data});

  final TextEditingController _usernameController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _usernameController.text = data['username'];
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            width: mediaQuery.size.width / 1.2,
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Tulis username disini',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: black), // Atur warna border
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = FirebaseFirestore.instance;
              db.collection("userData").doc(uid).set({
                "username": _usernameController.text,
              }, SetOptions(merge: true));
              Navigator.pop(context);
            },
            child: const Text('Upload'),
          ),
        ],
      )),
    );
  }
}
