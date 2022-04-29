import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/model/cartItemModel.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final CartItemModel cartItem;

  CartItem(this.cartItem);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  deleteCartItem(
      CartItemModel cart, AllProviders allpro, BuildContext context2) async {
    await RepositoryServiceTodo.deleteCartItem(cart, allpro);
    allpro.getCartItems();
    //getCartItemCount(context2);
    // await RepositoryServiceTodo.getAllCarts();
    isLoading = false;
  }

  bool isLoading = false;

  @override
  void initState() {
    //counter = widget.cartItem.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Column(
                      children: [
                        Container(
                          // alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              isLoading = true;
                              deleteCartItem(widget.cartItem, allpro, context);
                              setState(() {
                                allpro.getCartItems();
                                // allpro.getTotalPriceForCart();
                              });
                            },
                            child: isLoading == false
                                ? Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.redAccent,
                                  ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          height: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  print("this is the total : " +
                                      widget.cartItem.quantityTotal.toString());
                                  if (widget.cartItem.quantityTotal >
                                      widget.cartItem.quantity) {
                                    setState(() {
                                      widget.cartItem.quantity++;
                                      // allpro.getTotalPriceForCart();
                                    });
                                    await RepositoryServiceTodo.updateCart(
                                        widget.cartItem,
                                        widget.cartItem.quantity);
                                    allpro.getCartItems();
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: fonts,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .bottomAppBarColor),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.cartItem.quantity.toString(),
                                // AllProviders.selectedQuintity2.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: fonts,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (widget.cartItem.quantity > 1) {
                                    setState(() {
                                      widget.cartItem.quantity--;
                                      // allpro.getTotalPriceForCart();
                                    });
                                    await RepositoryServiceTodo.updateCart(
                                        widget.cartItem,
                                        widget.cartItem.quantity);
                                    allpro.getCartItems();
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: fonts,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .bottomAppBarColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.cartItem.color_code != ""
                      ? Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 4,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(int.parse(widget
                                                  .cartItem.color_code !=
                                              "No Color"
                                          ? "0xff${widget.cartItem.color_code.replaceAll("#", "")}"
                                          : "0xffffffff")),
                                      shape: BoxShape.circle),
                                  child: SizedBox(
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 5, right: 5),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.rectangle),
                                  child: Center(
                                      child: Text(
                                    widget.cartItem.size,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: fonts,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  //Text("${widget.cartItem.quantity} x"),
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: 100,
                              child: Text(
                                "${widget.cartItem.name}",
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: fonts,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.7)),
                              ),
                            ),
                          ),
                          Text(
                              allpro.numToString(
                                  widget.cartItem.price.toString()),
                              style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: fonts,
                                  color: Colors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          color: Colors.grey,
                          child: FadeInImage(
                            placeholder:
                                AssetImage('assets/images/placeholder.png'),
                            height: 80,
                            width: 80,
                            image: NetworkImage("${widget.cartItem.photo}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
