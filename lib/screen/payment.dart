import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/screen/home.dart';
import 'package:tubes_ppb/style/color.dart';

class Payment extends StatelessWidget {
  final Product data;
  Payment({super.key, required this.data});

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Tagihan Rp ${data.price}"),
            SizedBox(
              width: mediaQuery.size.width / 1.3,
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Tulis address disini',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: gray), // Atur warna border
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                ),
                // style: text_14_500,
              ),
            ),
            SizedBox(
              width: mediaQuery.size.width / 1.3,
              child: TextField(
                controller: _paymentController,
                decoration: InputDecoration(
                  labelText: 'Pament',
                  hintText: 'Tulis payment disini',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: gray), // Atur warna border
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                ),
                // style: text_14_500,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // cek apakah input angka?
                if (isNumeric(_paymentController.text)) {
                // cek apakah input lebih samadengan dari harga barang?
                  if (int.parse(_paymentController.text) >=
                      int.parse(data.price)) {
                    final int stokNow = int.parse(data.stock) - 1;
                    final db = FirebaseFirestore.instance;
                    db
                        .collection("product")
                        .doc(data.id)
                        .set({"stock": "$stokNow"}, SetOptions(merge: true));
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Home(),
                        ));
                  }
                }
              },
              child: const Text('Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
