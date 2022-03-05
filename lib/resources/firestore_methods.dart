import 'dart:typed_data';

import 'package:amigo_ordering_app/models/cart.dart';
import 'package:amigo_ordering_app/models/cart_product.dart';
import 'package:amigo_ordering_app/models/product.dart';
import 'package:amigo_ordering_app/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadProduct(
    String description,
    double price,
    int stock,
    String brand,
    List<Uint8List> file,
    String details,
    String uid,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      //Changed the scale of the uploadImageToStorage function to handle multiple files
      List<String> photoUrls = [];
      photoUrls = await Future.wait(file.map((image) =>
          (StorageMethods().uploadImageToStorage('products', image, true))));

      String postId = const Uuid().v1(); // creates unique id based on time
      Product post = Product(
          price: price,
          rating: [],
          details: details,
          variation: [],
          description: description,
          stock: stock,
          photoUrls: photoUrls,
          brand: brand);
      _firestore.collection('products').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// get cart details
  Future<Cart> getCartDetails() async {
    Cart cart = Cart(price: 0, productIDs: []);
    DocumentSnapshot? documentSnapshot;
    documentSnapshot =
        await _firestore.collection('carts').doc(_auth.currentUser!.uid).get();
    if (documentSnapshot.exists) {
      return Cart.fromSnap(documentSnapshot);
    } else {
      createCart([], 0, _auth.currentUser!.uid, 0,"", 0, "");
      return cart;
    }
  }

  Future<String> createCart(List productIDs, double price, String userID,
      double orderAmount, String name, int quantity, String productID) async {
    String res = "Internal Server Error. Please Contact Support.";
    try {
      Cart? cart = Cart(productIDs: productIDs, price: price);
      CartProduct? cp = CartProduct(
          productID: productID, orderAmount: orderAmount quantity: quantity, name: name, price: price);

      await _firestore.collection('carts').doc(userID).set(cart.toJson());
      await _firestore
          .collection('carts')
          .doc(userID)
          .collection('products')
          .doc(productID)
          .set(cp.toJson());
      res = "Success";
    } catch (error) {
      return res;
    }
    return res;
  }

  Future<String> deleteFromCart(String productID) async{
    String res = "Error deleting item.";
     try {
       _firestore.collection('carts').doc(_auth.currentUser!.uid).collection('products').doc(productID).delete();
       _firestore.collection('carts').doc(_auth.currentUser!.uid).update({"productIDs":FieldValue.arrayRemove([productID])});
       res = "Successfully deleted item from cart.";
     }  catch (e) {
       res = e.toString();
     }
    return  res;

  }
  Future<String> updateRating(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('products').doc(postId).update({
          'rating': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('products').doc(postId).update({
          'rating': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
