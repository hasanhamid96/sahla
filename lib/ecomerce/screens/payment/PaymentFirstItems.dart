import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/cartItemModel.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/screens/LoginScreen.dart';
import 'package:new_sahla/ecomerce/templetes/CartItem.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';



class PaymentFirstItems extends StatefulWidget {
  PageController c;

  PaymentFirstItems({this.c});

  @override
  State<PaymentFirstItems> createState() => _PaymentFirstItemsState();
}

class _PaymentFirstItemsState extends State<PaymentFirstItems> {
  @override
  Future<List<CartItemModel>> future;

  @override
  initState() {
    super.initState();
    future = RepositoryServiceTodo.getAllCarts();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    final allpro = Provider.of<AllProviders>(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width / 1.1,
        child: Column(
          children: <Widget>[
            Consumer<AllProviders>(
              builder: (ctx, pro, _) {
                if (pro.cartItemsAll == null) {
                  return Shimmer.fromColors(
                    baseColor: Colors.black87,
                    highlightColor: Colors.white,
                    period: Duration(milliseconds: 700),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 0.0,
                                  spreadRadius:
                                      0.1, // has the effect of extending the shadow
                                  offset: Offset(
                                    0, // horizontal, move right 10
                                    0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 0.0,
                                  spreadRadius:
                                      0.1, // has the effect of extending the shadow
                                  offset: Offset(
                                    0, // horizontal, move right 10
                                    0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return allpro.cartItemsAll != null &&
                          allpro.cartItemsAll.length != 0
                      ? Container(
                          margin: EdgeInsets.all(3),
                          width: MediaQuery.of(context).size.width / 1.1,
                          //height: MediaQuery.of(context).size.height / 4.1,
                          child: GridView.builder(
                            itemCount: allpro.cartItemsAll.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1 / 0.50,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1,
                            ),
                            itemBuilder: (ctx, index) {
                              return CartItem(allpro.cartItemsAll[index]);
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        )
                      : SizedBox();
                }
              },
            ),
            // Consumer<CartProvider>(
            //   builder: (ctx, data, _) {
            //     return Column(
            //       children: data.loadedAllCartItems.map((item) {
            //         return CartItem(item);
            //       }).toList(),
            //     );
            //   },
            // ),
            SizedBox(
              height: 100,
            ),
            RaisedButton(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    lang.translation['continue'][Languages.selectedLanguage],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: fonts,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onPressed: () {
                if (UserProvider.isLogin == true) {
                  widget.c.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                } else {
                  Flushbar(
                    title: Languages.selectedLanguage == 0
                        ? "تسجيل الدخول"
                        : "Sign In",
                    message: Languages.selectedLanguage == 0
                        ? "الرجاء تسجيل الدخول أولا للمتابعة"
                        : "Please Sign in first to continue",
                    barBlur: 0.4,
                    duration: Duration(milliseconds: 3000),
                    backgroundColor: Theme.of(context).primaryColor,
                    flushbarPosition: FlushbarPosition.TOP,
                    mainButton: Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text(Languages.selectedLanguage == 0
                            ? "تسجيل الدخول"
                            : "Sign In"),
                      ),
                    ),
                  ).show(context);
                  // showDialog(
                  //   context: context,
                  //   child: AlertDialog(
                  //     content: Text(
                  //       lang.translation['PleaseSignInFirst']
                  //           [Languages.selectedLanguage],
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(fontSize: 35),
                  //     ),
                  //     actions: [
                  //       Container(
                  //         child: RaisedButton(
                  //           color: Theme.of(context).primaryColor,
                  //           child: Text(
                  //             Languages.selectedLanguage == 0
                  //                 ? "
                  //                 : "Sign In",
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               shadows: [
                  //                 Shadow(
                  //                   color: Colors.grey,
                  //                   offset: Offset(0, 2),
                  //                   blurRadius: 10,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           onPressed: () {
                  //             Navigator.pop(context);
                  //           },
                  //         ),
                  //       )
                  //     ],
                  //     title: Container(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: <Widget>[
                  //           Icon(
                  //             Icons.warning,
                  //             color: Colors.redAccent,
                  //             size: 40,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     elevation: 2,
                  //   ),
                  // );
                }
              },
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
