import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  final int quantity;
  final String productID;
  final double orderAmount;
  final String name;
  final double price;
  const CartProduct(
      {required this.name,
      required this.orderAmount,
      required this.price,
      required this.quantity,
      required this.productID});
  static CartProduct fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return CartProduct(
      quantity: snap["quantity"],
      orderAmount: snap["orderAmount"],
      productID: snap["productID"],
      name: snap["name"],
      price: snap["price"],
    );
  }

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "productID": productID,
        "price": price,
        "name": name,
        "orderAmount": orderAmount
      };
}
