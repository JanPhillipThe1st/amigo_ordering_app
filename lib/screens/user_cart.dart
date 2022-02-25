import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:amigo_ordering_app/widgets/product_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              child: snapshot.data == null
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text("You have no items in your cart."),
                      ),
                    )
                  : ListView(),
            );
          },
        ));
  }
}
