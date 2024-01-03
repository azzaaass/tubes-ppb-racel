import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/component/detail_barang.dart';
import 'package:tubes_ppb/style/color.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final TextEditingController _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<String> getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (error) {
      return "hmm";
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        const Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Best product"),
                Text("Perfect choice"),
              ],
            ),
            FaIcon(FontAwesomeIcons.cartShopping),
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
        Expanded(
            child: Container(
          color: red,
          child: Stack(
            children: [
              Positioned(
                top: 50,
                child: Container(
                  height: mediaQuery.size.height,
                  width: mediaQuery.size.width,
                  decoration: BoxDecoration(
                      color: cyan,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100))),
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
                  // olah data
                  var _data = snapshot.data!.docs;
                  // Future <String> imageUrl = getImageUrl(_data[index]['image']);
                  return ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DetailBarang(
                                data: Product(
                                    id: _data[index].id,
                                    image: _data[index]['image'],
                                    name: _data[index]['name'],
                                    price: _data[index]['price'],
                                    stock: _data[index]['stock']),
                              ),
                            )),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    height: 100,
                                    child: Image.network(
                                      _data[index]['image'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Text(_data[index]['name'].toString()),
                                      Text(
                                          'Rp ${_data[index]['price'].toString()}'),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ))
      ],
    );
  }
}
