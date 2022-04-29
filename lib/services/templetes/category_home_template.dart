import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/model/Category.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/PressedHomeCategoryScreen.dart';
import 'package:provider/provider.dart';

class CategoryHomeTemplate extends StatefulWidget {
  final Category category;

  CategoryHomeTemplate({this.category});

  @override
  State<CategoryHomeTemplate> createState() => _CategoryHomeTemplateState();
}

class _CategoryHomeTemplateState extends State<CategoryHomeTemplate> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height / 5.6,
      child: InkWell(
        onTap: isLoading == false
            ? () {
                setState(() {
                  isLoading = true;
                });
                allPro
                    .fetchDataMainCategories(widget.category.id, "", "store",
                        widget.category.mainCategory)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                    // if (setPro.subCategories.length == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PressedHomeCategoryScreen(
                            category: widget.category),
                      ),
                    );
                  });
                });
              }
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 1.0,
                    offset: Offset(0, 4),
                    spreadRadius: 0.5)
              ],
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 600,
                    fadeInCurve: Curves.bounceOut,
                    imageUrl: "${widget.category.image}",
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        fit: BoxFit.cover,
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: isLoading == false
                        ? Text(
                            widget.category.mainCategory,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: fonts,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(
                            padding: EdgeInsets.all(3),
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.2,
                            )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
