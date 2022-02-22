import 'dart:typed_data';

import 'package:amigo_ordering_app/resources/auth_methods.dart';
import 'package:amigo_ordering_app/resources/firestore_methods.dart';
import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:amigo_ordering_app/utils/utils.dart';
import 'package:amigo_ordering_app/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

late List<Uint8List> _files = [];

class _AddProductScreenState extends State<AddProductScreen> {
  late TextEditingController priceController =
      TextEditingController(text: '0.00');
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController ratingController = TextEditingController();
  late TextEditingController variationController = TextEditingController();
  late TextEditingController stockController = TextEditingController(text: '0');
  late TextEditingController photoUrlController = TextEditingController();
  late TextEditingController brandController = TextEditingController();
  late TextEditingController detailsController = TextEditingController();
  late bool _isLoading = false;
  late String _res;

  final FireStoreMethods _fireStore = FireStoreMethods();
  late FirebaseAuth _auth;
  //create a widget list by iterating through images.
  @override
  void dispose() {
    super.dispose();
    _files = [];
  }

  List<Image> getImageWidgets(List<Uint8List>? album) {
    late List<Image> images = [];
    for (Uint8List? image in album!) {
      images.add(Image.memory(image!));
    }
    return images;
  }

  selectImage() async {
    List<XFile>? files = await ImagePicker().pickMultiImage();
    for (XFile file in files!) {
      _files.add(await file.readAsBytes());
    }
    // set state because we need to display the image we selected on the circle avatar
  }

  uploadProduct() async {
    setState(() {
      _isLoading = true;
    });
    _auth = FirebaseAuth.instance;
    if (descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        stockController.text.isNotEmpty &&
        brandController.text.isNotEmpty &&
        detailsController.text.isNotEmpty &&
        _files != null &&
        _files.isNotEmpty &&
        _auth.currentUser!.uid.isNotEmpty) {
      String res = await _fireStore.uploadProduct(
        descriptionController.text,
        double.parse(priceController.text),
        int.parse(stockController.text),
        brandController.text,
        _files,
        detailsController.text,
        _auth.currentUser!.uid,
      );
      setState(() {
        _res = res;
      });
    } else {
      setState(() {
        _res = 'Fields are not completely filled';
      });
    }
    setState(() {
      _isLoading = false;
    });
    showSnackBar(context, _res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/amigo-ordering.svg',
          color: primaryColor,
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20),
        children: [
          Center(
            child: _files != null
                ? Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(bottom: 50)),
                      Container(
                        color: mobileSearchColor,
                        width: MediaQuery.of(context).size.width * .5,
                        child: CarouselSlider(
                            items: getImageWidgets(_files),
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 1,
                              enlargeCenterPage: true,
                            )),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Positioned(
                          child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: selectImage,
                      )),
                      Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  )
                : Positioned(
                    child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: selectImage,
                  )),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 60,
              child: TextFieldInput(
                textInputType: TextInputType.text,
                textEditingController: descriptionController,
                hintText: 'Description',
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              child: TextFieldInput(
                textInputType: TextInputType.number,
                textEditingController: priceController,
                hintText: 'Price',
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              child: TextFieldInput(
                textInputType: TextInputType.number,
                textEditingController: stockController,
                hintText: 'Stock',
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              child: TextFieldInput(
                textInputType: TextInputType.text,
                textEditingController: brandController,
                hintText: 'Brand',
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 65,
              child: TextFieldInput(
                textInputType: TextInputType.multiline,
                multiLine: true,
                textEditingController: detailsController,
                hintText: 'Details',
              )),
          InkWell(
            onTap: uploadProduct,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50,
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              child: !_isLoading
                  ? const Text(
                      'Add Product',
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }
}
