import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:amigo_ordering_app/widgets/product_display.dart';
import 'package:amigo_ordering_app/widgets/search_button.dart';
import 'package:amigo_ordering_app/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchProduct extends StatefulWidget {
  SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _searchTermController = TextEditingController();
    final String _searchTerm = "";
    bool _searching = false;

    ProductDisplay searchProduct() {
      setState(() {
        _searching = true;
      });
      return ProductDisplay(searchTerm: _searchTermController.text);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/amigo-ordering.svg',
            color: primaryColor,
            height: 32,
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: TextFieldInput(
                        textEditingController: _searchTermController,
                        hintText: "Search Product",
                        textInputType: TextInputType.text,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          color: primaryColor),
                      child: IconButton(
                          splashColor: primaryColor,
                          splashRadius: 1,
                          icon: Icon(Icons.search),
                          onPressed: () {
                            searchProduct();
                          }),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: _searching ? searchProduct() : Text("No data.")),
            ],
          ),
        ));
  }
}
