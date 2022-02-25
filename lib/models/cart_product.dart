import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  final int quantity;
  final String productID;
  const CartProduct({required this.quantity, required this.productID});
  static CartProduct fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return CartProduct(
      quantity: snap["quantity"],
      productID: snap["productID"],
    );
  }

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "productID": productID,
      };
}
