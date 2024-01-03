import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/component/add_barang.dart';
import 'package:tubes_ppb/component/detail_barang.dart';
import 'package:tubes_ppb/data/data.dart';
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
          StreamBuilder(
            stream: db.collection("product").snapshots(),
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
              var data = snapshot.data!.docs;
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    print(data.runtimeType);
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DetailBarang(
                            data: Product(
                                id: data[index].id,
                                image: data[index]['image'],
                                name: data[index]['name'],
                                price: data[index]['price'],
                                stock: data[index]['stock'],
                                desc: data[index]['desc']),
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: red),
                        child: Column(
                          children: [
                            Expanded(
                                child: SizedBox(
                                    width: mediaQuery.size.width,
                                    child: Image.network(
                                      data[index]['image'],
                                      fit: BoxFit.cover,
                                    ))),
                            Expanded(
                                child: Column(
                              children: [
                                Text(data[index]['name']),
                                Text("Rp ${data[index]['price']}"),
                              ],
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
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
