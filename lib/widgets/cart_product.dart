import 'package:amigo_ordering_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:amigo_ordering_app/models/cart_product.dart' as model;

class CartProduct extends StatefulWidget {
  final model.CartProduct product;
  const CartProduct({Key? key, required this.product}) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
