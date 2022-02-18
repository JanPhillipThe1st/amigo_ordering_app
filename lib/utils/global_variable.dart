import 'package:amigo_ordering_app/screens/add_product_screen.dart';
import 'package:amigo_ordering_app/screens/profile_screen.dart';
import 'package:amigo_ordering_app/screens/shopping_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  AddProductScreen(),
  const Text('notifications'),
  ShoppingScreen(),
  const Text('notifications'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
];
