import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/component/edit_barang.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/screen/payment.dart';
import 'package:tubes_ppb/style/color.dart';

class DetailBarang extends StatelessWidget {
  final Product data;

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  DetailBarang({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Stack(
        children: [
          Container(
            padding: EdgeInsets.all(40),
            height: mediaQuery.size.height / 2,
            width: mediaQuery.size.width,
            decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Image.network(
              data.image,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.angleLeft),
              SizedBox(
                width: 5,
              ),
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text("Detail barang")),
            ],
          ),
        ],
      ),
      Expanded(
          child: Container(
        width: mediaQuery.size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.name),
            Text("Rp ${data.price}"),
            // Text(role),
            ElevatedButton(
              onPressed: () {
                // cek apakah stok barang masih ada?
                if (int.parse(data.stock) > 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment(data: data),
                      ));
                }
              },
              child: const Text('Buy Now'),
            ),
            StreamBuilder(
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
                var result = snapshot.data!.data();
                // print(data?['role']);
                if (result?['role'] == 'admin') {
                  return Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => EditBarang(
                                    data: data,
                                  ),
                                ));
                          },
                          child: Text("Edit"))
                    ],
                  );
                }
                return SizedBox();
              },
            )
          ],
        ),
      ))
    ])));
  }
}
