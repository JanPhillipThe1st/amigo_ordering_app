import 'package:amigo_ordering_app/screens/add_product_screen.dart';
import 'package:amigo_ordering_app/screens/profile_screen.dart';
import 'package:amigo_ordering_app/screens/shopping_screen.dart';
import 'package:amigo_ordering_app/screens/user_cart.dart';
import 'package:amigo_ordering_app/screens/search_product_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  AddProductScreen(),
  SearchProduct(),
  ShoppingScreen(),
  const UserCartScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
];
