import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/component/add_barang.dart';
import 'package:tubes_ppb/style/color.dart';

class Barang extends StatelessWidget {
  Barang({super.key});

  final TextEditingController _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Best product"),
              Text("Perfect choice"),
            ],
          ),
          SizedBox(
            width: mediaQuery.size.width / 1.2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Tulis email disini',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: gray), // Atur warna border
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              ),
            ),
          ),
          // StreamBuilder(
          //   stream: db.collection("product").snapshots(),
          //   builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // if (snapshot.hasError) {
          //   return const Center(
          //     child: Text("Error"),
          //   );
          // }
          // return GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2),
          //   itemBuilder: (context, index) {
          //     var data = snapshot.data!.docs;
          //     return Container(
          //       child: Text(data[index]['name']),
          //     );
          //   },
          // );
          //   },
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddBarang(),
              ));
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
