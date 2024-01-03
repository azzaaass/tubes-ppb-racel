import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/screen/home.dart';
import 'package:tubes_ppb/style/color.dart';

class EditBarang extends StatefulWidget {
  final Product data;
  const EditBarang({super.key, required this.data});

  @override
  State<EditBarang> createState() => EditBarangState();
}

class EditBarangState extends State<EditBarang> {
  File? _image;
  final picker = ImagePicker();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = widget.data.name;
    _priceController.text = widget.data.price;
    _stockController.text = widget.data.stock;
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(String id) async {
    if (_image != null) {
      Reference ref = FirebaseStorage.instance.ref().child('product/$id');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
      print('Image URL: $imageURL');
      return imageURL;
    } else {
      print('No image selected.');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          _image != null
              ? Image.file(
                  _image!,
                  height: 200,
                  width: 200,
                )
              : SizedBox(
                  height: mediaQuery.size.height / 3,
                  child: Image.network(widget.data.image)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: getImage,
            child: const Text('Select Image'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(FontAwesomeIcons.signature),
              SizedBox(
                width: mediaQuery.size.width / 1.3,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Tulis name disini',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: gray), // Atur warna border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                  ),
                  // style: text_14_500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(FontAwesomeIcons.boxesStacked),
              SizedBox(
                width: mediaQuery.size.width / 1.3,
                child: TextField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Tulis stock disini',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: gray), // Atur warna border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                  ),
                  // style: text_14_500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(FontAwesomeIcons.tags),
              SizedBox(
                width: mediaQuery.size.width / 1.3,
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Tulis price disini',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: gray), // Atur warna border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                  ),
                  // style: text_14_500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  String productID = widget.data.id;
                  if (_image != null) {
                    String url = await uploadImageToFirebase(productID);
                    final db = FirebaseFirestore.instance;
                    db.collection("product").doc(productID).set({
                      "image": url,
                      "name": _nameController.text,
                      "stock": _stockController.text,
                      "price": _priceController.text
                    });
                  } else {
                    final db = FirebaseFirestore.instance;
                    db.collection("product").doc(productID).set({
                      "name": _nameController.text,
                      "stock": _stockController.text,
                      "price": _priceController.text
                    }, SetOptions(merge: true));
                  }
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Home(),
                      ));
                },
                child: const Text('update'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String productID = widget.data.id;
                    final db = FirebaseFirestore.instance;
                    Reference storageRef = FirebaseStorage.instance.ref();
                    db.collection("product").doc(productID).delete();

                    final desertRef = storageRef.child("product/$productID");
                    await desertRef.delete();
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Home(),
                        ));
                  },
                  child: const Text('Delete'))
            ],
          ),
        ],
      ),
    ));
  }
}
