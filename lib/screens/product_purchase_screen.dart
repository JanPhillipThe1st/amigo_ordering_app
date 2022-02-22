import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductPurchase extends StatefulWidget {
  final snapshot;
  ProductPurchase({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<ProductPurchase> createState() => _ProductPurchaseState();
}

class _ProductPurchaseState extends State<ProductPurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 40)),
          Container(
            color: mobileSearchColor,
            child: Center(
              child: Text(
                'You are buying: ${widget.snapshot['description']}\nfor P ${widget.snapshot['price'].toString()}',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Container(
            child: const Text(
              "You'r'e order's am being frassest.",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
