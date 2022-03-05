import 'package:amigo_ordering_app/models/cart_product.dart';
import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:amigo_ordering_app/widgets/product_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amigo_ordering_app/widgets/cart_product.dart' as widgets;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({Key? key}) : super(key: key);

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/amigo-ordering.svg',
          color: primaryColor,
          height: 32,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(_auth.currentUser!.uid)
            .collection('products')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              child: !snapshot.hasData
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text("You have no items in your cart."),
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: widgets.CartProduct(
                          snapshot: snapshot.data!.docs[index].data(),
                          id: snapshot.data!.docs[index].id,
                        ),
                      ),
                    ));
        },
      ),
      bottomNavigationBar: InkWell(
        child: Container(
          color: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            "Confirm order",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
