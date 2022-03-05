import 'package:amigo_ordering_app/models/product.dart';
import 'package:amigo_ordering_app/resources/firestore_methods.dart';
import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:amigo_ordering_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:amigo_ordering_app/models/cart_product.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class CartProduct extends StatefulWidget {
  final snapshot;
  final id;
  const CartProduct({Key? key, required this.snapshot, required this.id})
      : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
FireStoreMethods _fireStore = FireStoreMethods();

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    void deleteProductFromCart() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:
              Text("Are you sure you want to remove this item from your cart?"),
          actions: [
            TextButton(
              onPressed: () async {
                String res = await _fireStore.deleteFromCart(widget.id);
                Navigator.pop(context);
                showSnackBar(context, res);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Nope"),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: ShapeDecoration(
          color: paleBeige,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onVerticalDragDown: (details) {
              showSnackBar(
                  context, " Drag down details ${details.globalPosition}");
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.snapshot["name"].toString()}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                  ),
                  Text(
                    "₱ ${widget.snapshot["price"].toString()} x ${widget.snapshot["quantity"].toString()} pieces",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                  ),
                  Text(
                    "Order Amount: ₱ ${widget.snapshot["orderAmount"].toString()}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width * 0.3,
            child: IconButton(
              onPressed: deleteProductFromCart,
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
