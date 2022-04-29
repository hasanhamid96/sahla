
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/screens/AddressesScreen.dart';
import 'package:new_sahla/ecomerce/templetes/address_order_template.dart';
import 'package:provider/provider.dart';

class PaymentSecondPayAddress extends StatefulWidget {
  PageController c;

  PaymentSecondPayAddress({this.c});

  static String radioItem = 'null';

  @override
  State<PaymentSecondPayAddress> createState() => _PaymentSecondPayAddressState();
}

class _PaymentSecondPayAddressState extends State<PaymentSecondPayAddress> {
  int totalPointsWithPrice = 0;

  bool once = true;

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    final lang = Provider.of<Languages>(context);

    if (once) {
      once = false;
    }
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 1.1,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              lang.translation['shippingAddressTitle']
              [Languages.selectedLanguage],
              style: TextStyle(
                  fontFamily: fonts,
                  color: Theme
                      .of(context)
                      .bottomAppBarColor),
            ),
            Divider(
              endIndent: 100,
              indent: 100,
            ),
            allPro.selectedAddress != null
                ? AddressOrderTemplate(allPro.selectedAddress, false)
                : Text(
              lang.translation['noAddressSelectred']
              [Languages.selectedLanguage],
              style: TextStyle(
                fontSize: 20,
                fontFamily: fonts,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .bottomAppBarColor,
              ),
            ),
            SizedBox(
              height: 20,
            ), // this is the order address template
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 20),
              child: RaisedButton(
                child: Text(
                  lang.translation['EditAddress'][Languages.selectedLanguage],
                  style: TextStyle(
                      fontFamily: fonts,
                      color: Colors.white, fontSize: 19),
                ),
                onPressed: () {
                  RepositoryServiceTodo.getAllAddress(allpro: allPro).then((value) {
                    //    allPro.getCity(int.parse("")).then((value) {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressesScreen(),
                        ));
                  });
                },
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(lang.translation['PaymentTitle'][Languages.selectedLanguage],
                style: TextStyle(
                    fontFamily: fonts,
                    color: Theme
                        .of(context)
                        .bottomAppBarColor)),
            Divider(
              endIndent: 100,
              indent: 100,
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.1,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          lang.translation['payOnDelivered']
                          [Languages.selectedLanguage],
                          style: TextStyle(
                              fontFamily: fonts,
                              color: Theme
                                  .of(context)
                                  .bottomAppBarColor)),
                      Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Theme
                                .of(context)
                                .textTheme
                                .headline3
                                .color,
                            disabledColor: Theme
                                .of(context)
                                .textTheme
                                .headline3
                                .color
                        ),
                        child: Radio(
                          value: '0',
                          activeColor: Theme
                              .of(context)
                              .primaryColor,
                          groupValue: PaymentSecondPayAddress.radioItem,
                          onChanged: (val) {
                            setState(() {
                              PaymentSecondPayAddress.radioItem = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     Text(
                  //         lang.translation['payUsingPoints']
                  //         [Languages.selectedLanguage],
                  //         style: TextStyle(
                  //             color: Theme.of(context).bottomAppBarColor)),
                  //     Radio(
                  //       value: '1',
                  //       activeColor: Theme.of(context).primaryColor,
                  //       groupValue: PaymentSecondPayAddress.radioItem,
                  //       onChanged: (val) {
                  //         setState(() {
                  //           PaymentSecondPayAddress.radioItem = val;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            RaisedButton(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.1,
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
                if (PaymentSecondPayAddress.radioItem == 'null' ||
                    allPro.selectedAddress == null) {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        content: Text(
                          lang.translation['pleaseSelectValidShippingAddress']
                          [Languages.selectedLanguage],
                          textAlign: TextAlign.center,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline1,
                        ),
                        title: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.warning,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                        elevation: 2,
                      );
                    },
                  );
                }
                else if (allPro.selectedAddress != null &&
                   PaymentSecondPayAddress.radioItem == '0') {
                  allPro.getTotalPrice(0.0);
                  allPro.promocode.amount = '0';
                  widget.c.animateToPage(2,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
                else if (allPro.selectedAddress != null &&
                PaymentSecondPayAddress.radioItem == '1') {
                  // print(UserProvider.points);
                  allPro.getTotalPrice(0.0);
                  allPro.promocode.amount = '0';
                  // totalPointsWithPrice = (allPro.lastlastTotalPrice *
                  //     UserProvider.pointPerCurrency);
                  // if(totalPointsWithPrice>int.parse(UserProvider.points)){
                  //   showDialog(
                  //     context: context,
                  //     builder: (ctx) {
                  //       return AlertDialog(
                  //         content: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment:Languages.selectedLanguage==1?
                  //           CrossAxisAlignment.start:
                  //           CrossAxisAlignment.end,
                  //           children: [
                  //             Text(
                  //               lang.translation['don\'tHaveEnoughPoints']
                  //               [Languages.selectedLanguage],
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(fontSize: 20),
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:Languages.selectedLanguage==1?
                  //               MainAxisAlignment.start:
                  //               MainAxisAlignment.end,
                  //               children: [
                  //                 Text(
                  //                   '${totalPointsWithPrice}' ,
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //                 SizedBox(width: 5,),
                  //                 Text(
                  //                   lang.translation['requirePoints']
                  //                   [Languages.selectedLanguage],
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //               ],
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:Languages.selectedLanguage==1?
                  //               MainAxisAlignment.start:
                  //               MainAxisAlignment.end,
                  //               children: [
                  //                 Text(
                  //                   '${int.parse(UserProvider.points)}' ,
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //                 SizedBox(width: 5,),
                  //                 Text(
                  //                   '${lang.translation['yourPoints'][Languages.selectedLanguage]}',
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         title: Container(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Icon(
                  //                 Icons.warning,
                  //                 color: Colors.redAccent,
                  //                 size: 40,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         elevation: 2,
                  //       );
                  //     },
                  //   );
                  // }
                  widget.c.animateToPage(2,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              },
              color: Theme
                  .of(context)
                  .primaryColor,
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