import 'package:amigo_ordering_app/widgets/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  double price;
  List productIDs = [];
  Cart({required this.price, required this.productIDs});

  static Cart fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Cart(price: snapshot["price"], productIDs: snapshot["productIDs"]);
  }

  Map<String, dynamic> toJson() => {"price": price, "productIDs": productIDs};
}
