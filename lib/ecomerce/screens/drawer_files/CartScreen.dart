
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/screens/payment/PaymentFirstItems.dart';
import 'package:new_sahla/ecomerce/screens/payment/PaymentSecondPayAddress.dart';
import 'package:new_sahla/ecomerce/screens/payment/PaymentThirdConfirm.dart';
import 'package:new_sahla/ecomerce/widgets/CartNoProducts.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatelessWidget {
  final PageController controller;
  CartScreen({this.controller});
  PageController c = new PageController();
  String thePage = '';
  String fonts = 'ithra';
  int pageNumber =0;
  void setThePageSetUppers(int page) {
    pageNumber = page;
    // setState(() {
    //   if (page == 0) {
    //     thePage = "
    //   } else if (page == 1) {
    //     thePage = "
    //   } else {
    //     thePage = "
    //   }
    // });
   }
    @override
    Widget build(BuildContext context) {
      print('$pageNumber pageNumber');
      final lang = Provider.of<Languages>(context);
      final allpro = Provider.of<AllProviders>(context);
      List<Widget> theGoldCarsWidget = [
        PaymentFirstItems(c: c,),
        PaymentSecondPayAddress(c: c,), PaymentThirdConfirm(c: c,controller: controller,),

      ];
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            lang.translation['shoppingBasket'][Languages.selectedLanguage],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: fonts,
              color: Colors.white,
            ),
          ),
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          },icon: Icon(Icons.arrow_back_ios,
            color: Colors.white,),),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.only(top: 0, bottom: 0),
                //   width: MediaQuery.of(context).size.width / 1.1,
                //   //alignment: Alignment.centerRight,
                //   child: Text('',),
                // ),
                allpro.cartItemsAll != null && allpro.cartItemsAll.length != 0
                    ? FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          lang.translation['cartTitle']
                          [Languages.selectedLanguage],
                          style: TextStyle(
                            fontFamily: fonts,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                        onPressed: pageNumber >= 0
                            ? () {
                          UserProvider.points=UserProvider.newPoints;
                          c.jumpToPage(0);
                        }
                            : null,
                      ),
                      SizedBox(
                        width: 20,
                        child: Divider(
                          thickness: 3,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          lang.translation['addressAndPaying']
                          [Languages.selectedLanguage],
                          style: TextStyle(
                            fontFamily: fonts,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                        onPressed: pageNumber >= 1
                            ? () {
                          UserProvider.points=UserProvider.newPoints;
                          c.jumpToPage(1);
                        }
                            : null,
                      ),
                      SizedBox(
                        width: 20,
                        child: Divider(
                          thickness: 3,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          lang.translation['Confirmation']
                          [Languages.selectedLanguage],
                          style: TextStyle(
                            fontFamily: fonts,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                        onPressed: pageNumber >= 2
                            ? () {
                          UserProvider.points=UserProvider.newPoints;
                          c.jumpToPage(2);
                        }
                            : null,
                      ),
                    ],
                  ),
                )
                    : SizedBox(),
                allpro.cartItemsAll != null && allpro.cartItemsAll.length != 0
                    ? Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: c,
                      physics: NeverScrollableScrollPhysics(),
                      children: theGoldCarsWidget,
                      onPageChanged: (page) {
                        setThePageSetUppers(page);
                      },
                    ),
                  ),
                )
                    : SizedBox(),
                SizedBox(
                  height: 100,
                ),
                //CartNoProducts(),
                allpro.cartItemsAll == null || allpro.cartItemsAll.length == 0
                    ? Center(
                  child: CartNoProducts(
                    controller: controller,
                  ),
                )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      );}
  }