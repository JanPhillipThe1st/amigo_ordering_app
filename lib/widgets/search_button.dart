import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatefulWidget {
  VoidCallback myVoidCallback = () {};
  SearchButton({Key? key, required this.myVoidCallback}) : super(key: key);

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    final inputBorder = Border(
      top: Divider.createBorderSide(context),
    );
    return Container(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          color: primaryColor),
      child: IconButton(
        splashColor: primaryColor,
        splashRadius: 1,
        icon: Icon(Icons.search),
        onPressed: widget.myVoidCallback,
      ),
    );
  }
}
