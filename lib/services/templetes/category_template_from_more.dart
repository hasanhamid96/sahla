import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/model/Category.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/PressedHomeCategoryScreen.dart';
import 'package:provider/provider.dart';
class CategoryTemplateFromMore extends StatefulWidget {
  final Category category;
  final PageController controller;
  final bool isLoading;
  CategoryTemplateFromMore({this.category, this.controller, this.isLoading});


  @override
  State<CategoryTemplateFromMore> createState() => _CategoryTemplateFromMoreState();
}

class _CategoryTemplateFromMoreState extends State<CategoryTemplateFromMore> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
  final setPro = Provider.of<AllProviders>(context);
  return InkWell(
  onTap: () {
  setState(() {
  isLoading = true;
  });
  print('fetch category1...');
  setPro
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
  // setPro
  //     .fetchDataMainCategories(
  //         widget.category.id, "", "store", widget.category.mainCategory,)
  //     .then((value) {
  //   setState(() {
  //     isLoading = false;
  //     Navigator.push(context,
  //         CupertinoPageRoute(builder: (context) => Category1(),));
  //
  //   });
  // });
  },
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
  color: Colors.grey.withOpacity(0.2),
  blurRadius: 1.0,
  offset: Offset(0, 2),
  spreadRadius: 0.2)
  ]),
  child: Stack(
  children: <Widget>[
  Container(
  width: 300,
  height: 300,
  child: CachedNetworkImage(
  fit: BoxFit.fill,
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
  Align(
  alignment: Alignment.bottomCenter,
  child: Container(
  color: Colors.black.withOpacity(0.3),
  // height: 100,
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
  widget.isLoading == false
  ? Container(
  alignment: Alignment.center,
  padding: EdgeInsets.all(5),
  child: setPro.catMainStyle == 0
  ? Container(
  width: 150,
  child: Center(
  child: Text(
  "${widget.category.mainCategory}",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.white,
  fontFamily: fonts,
  fontSize: 17,
  //decoration: TextDecoration.lineThrough,
  fontWeight: FontWeight.bold),
  ),
  ),
  )
      : Container(
  width: 90,
  child: Text(
  "${widget.category.mainCategory}",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontFamily: fonts,
  //decoration: TextDecoration.lineThrough,
  fontWeight: FontWeight.bold),
  ),
  ),
  )
      : Container(
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(5),
  width: 50,
  height: 50,
  child: CircularProgressIndicator()),
  ],
  ),
  ),
  ),
  ],
  ),
  ),
  ),
  );}}