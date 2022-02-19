import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final double price;
  final String description;
  final rating;
  final variation;
  final int stock;
  final List photoUrl;
  final String brand;
  final String details;

  const Product({
    required this.price,
    required this.description,
    this.rating,
    this.variation,
    required this.stock,
    required this.photoUrl,
    required this.brand,
    this.details = '',
  });

  static Product fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Product(
        price: snapshot["price"],
        description: snapshot["description"],
        rating: snapshot["rating"],
        variation: snapshot["variation"],
        stock: snapshot["stock"],
        photoUrl: snapshot["photoUrl"],
        brand: snapshot['brand'],
        details: snapshot['details']);
  }

  Map<String, dynamic> toJson() => {
        "price": price,
        "description": description,
        "rating": rating,
        "variation": variation,
        "stock": stock,
        "photoUrl": photoUrl,
        'brand': brand,
        'details': details
      };
}
