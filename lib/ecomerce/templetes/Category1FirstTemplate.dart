import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/model/SubCategory.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/widgets/SubCategoryScreen.dart';
import 'package:new_sahla/ecomerce/widgets/ThirdCatProducts.dart';
import 'package:provider/provider.dart';

class Category1FirstTemplate extends StatelessWidget {
  final SubCategory subCategory;
  final PageController controller;
  bool isThird;

  Category1FirstTemplate(
      {this.subCategory, this.controller, this.isThird: false});

  @override
  Widget build(BuildContext context) {
    final setPro = Provider.of<AllProviders>(context);
    return InkWell(
      onTap: () {
        AllProviders.isSubCateforyProductsOk = false;
        setPro.loadedAllCategoriesProducts = [];
        setPro.loadedAllsubCategoriesProducts = [];
        if (isThird) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThirdCatProducts(
                subCategory: subCategory,
              ),
            ),
          );
        } else {
          print('fetching.....');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategoryScreen(
                subCategory: subCategory,
              ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 800,
          height: 800,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: Offset(0, 2),
                    spreadRadius: 0.2)
              ]),
          child: Stack(
            children: <Widget>[
              Container(
                width: 800,
                height: 800,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: NetworkImage(
                    "${subCategory.photo}",
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "${subCategory.title}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: fonts,
                                //decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
