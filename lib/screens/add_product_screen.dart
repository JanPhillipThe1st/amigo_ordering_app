import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: (Center(
        child: Text(
          'Fuck you',
          style: TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.w300, fontSize: 18),
        ),
      )),
    );
  }
}
