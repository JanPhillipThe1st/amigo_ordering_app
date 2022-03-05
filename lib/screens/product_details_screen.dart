import 'package:amigo_ordering_app/models/cart.dart';
import 'package:amigo_ordering_app/models/cart_product.dart';
import 'package:amigo_ordering_app/resources/auth_methods.dart';
import 'package:amigo_ordering_app/utils/colors.dart';
import 'package:amigo_ordering_app/utils/utils.dart';
import 'package:amigo_ordering_app/widgets/text_field_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amigo_ordering_app/resources/firestore_methods.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetails extends StatefulWidget {
  final snapshot;
  final id;
  ProductDetails({Key? key, required this.snapshot, required this.id})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 0;
  double orderAmount = 0;
  TextEditingController quantityController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Cart _cart = Cart(
    productIDs: [],
    price: 0,
  );
  List<String> ratings = [];
  bool _isLoading = false;
  final FireStoreMethods _fireStore = FireStoreMethods();
  List<Image> getImageWidgets() {
    List<Image> image = [];
    for (String imageUrl in widget.snapshot['photoUrl']) {
      image.add(Image.network(imageUrl));
    }
    return image;
  }

  controlQuantity(bool subtract) {
    setState(() {
      subtract ? quantity++ : quantity--;
    });
    if (quantity <= 1) {
      quantity = 1;
    }

    quantityController.text = quantity.toString();
  }

  addToCart() async {
    setState(() {
      _isLoading = true;
    });
    Cart cart = await (_fireStore.getCartDetails());

    if (cart.productIDs.any((element) => widget.id == element)) {
      showSnackBar(context, "Product is already in your cart");

      setState(() {
        _isLoading = false;
      });
      return;
    } else {
      cart.price += (quantity * widget.snapshot['price']);
      cart.productIDs.add(widget.id);
      setState(() {
        _cart = cart;
        orderAmount += (quantity * widget.snapshot['price']);
      });
      String res = await _fireStore.createCart(
          cart.productIDs,
          widget.snapshot["price"],
          _auth.currentUser!.uid,
          orderAmount,
          widget.snapshot["description"],
          quantity,
          widget.id);
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  updateRating() async {
    await _fireStore.updateRating(widget.id, _auth.currentUser!.uid, []);
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 40)),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                color: mobileSearchColor,
                child: Center(
                  child: CarouselSlider(
                    items: getImageWidgets(),
                    options: CarouselOptions(),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.snapshot['description'].toString(),
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: primaryColor),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  widget.snapshot['price'].toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 10, top: 10, bottom: 10),
                      child: Text(
                        'Rating: (${widget.snapshot['rating'].length.toString()})',
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: 20,
                    child: RatingBar.builder(
                        itemSize: 20,
                        initialRating: 1,
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: yellowish,
                              size: 1,
                            ),
                        onRatingUpdate: (rating) => updateRating()),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  'Details:\n\n${widget.snapshot['details'].toString()}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => (controlQuantity(false)),
                        icon: Icon(Icons.remove_circle_outline_outlined)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextFieldInput(
                        textEditingController: quantityController,
                        hintText: "Quantity",
                        centered: true,
                        textInputType: TextInputType.number,
                        isNumber: true,
                      ),
                    ),
                    IconButton(
                        onPressed: () => (controlQuantity(true)),
                        icon: Icon(Icons.add_circle_outline_outlined)),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              color: blueColor,
            ),
            child: InkWell(
              onTap: addToCart,
              child: Container(
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Add to cart',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
