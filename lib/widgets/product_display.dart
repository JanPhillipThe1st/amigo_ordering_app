import 'package:amigo_ordering_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDisplay extends StatefulWidget {
  String searchTerm = "";
  ProductDisplay({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('description', isGreaterThanOrEqualTo: widget.searchTerm)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                child: ProductCard(
                  snapshot: snapshot.data!.docs[index].data(),
                  id: snapshot.data!.docs[index].id,
                ),
              ),
            );
          }),
    );
  }
}
