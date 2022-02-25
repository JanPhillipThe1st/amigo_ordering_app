import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  double price;
  final List products;

  Cart({required this.price, required this.products});

  static Cart fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Cart(
      price: snapshot["price"],
      products: snapshot["products"],
    );
  }

  Map<String, dynamic> toJson() => {
        "price": price,
        "products": products,
      };
}
