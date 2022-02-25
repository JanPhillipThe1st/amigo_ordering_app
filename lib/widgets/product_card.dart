import 'package:amigo_ordering_app/models/product.dart';
import 'package:amigo_ordering_app/screens/add_product_screen.dart';
import 'package:amigo_ordering_app/screens/product_details_screen.dart';
import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductCard extends StatefulWidget {
  final snapshot;
  final id;
  ProductCard({Key? key, required this.snapshot, required this.id})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<Image> imageUrls = [];
  List<Image> getImages() {
    for (String imageUrl in widget.snapshot['photoUrl']) {
      imageUrls.add(Image(image: NetworkImage(imageUrl)));
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: const ShapeDecoration(
          color: mobileSearchColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)))),
      child: Column(children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        CarouselSlider(
          items: getImages(),
          options: CarouselOptions(enableInfiniteScroll: false),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              margin: const EdgeInsets.only(left: 10, bottom: 5),
              child: Text(
                widget.snapshot['description'],
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              margin: const EdgeInsets.only(left: 10, bottom: 15),
              child: Text(
                widget.snapshot['price'].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Container(
            margin: const EdgeInsets.only(left: 10, bottom: 15),
            child: Text(
              'Brand: ${widget.snapshot['brand'].toString()}',
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Container(
                    margin: const EdgeInsets.only(left: 2, bottom: 15),
                    child: Text(
                      'Stocks left: ${widget.snapshot['stock'].toString()}',
                      style: const TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(
                            id: widget.id,
                            snapshot: widget.snapshot,
                          ))),
              highlightColor: Colors.amberAccent,
              radius: 100,
              splashColor: Colors.white,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                decoration: ShapeDecoration(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Text('Buy'),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
