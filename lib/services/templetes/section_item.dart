import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/Section.dart';
import 'package:new_sahla/services/screens/category_screen.dart';
import 'package:provider/provider.dart';
class SectionItem extends StatefulWidget {
  Section section;
  Size mediaQuery;
  SectionItem({Key key,this.section,this.mediaQuery}) : super(key: key);

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
  final setPro=Provider.of<AllProviders>(context);
  return     Container(
  margin: EdgeInsets.all(5),
  child: InkWell(
  onTap:isLoading?null: () {
  setState(() {
  isLoading=true;
  });
  Future.delayed(Duration(milliseconds: 200)).then((value){
  setState(() {
  isLoading=false;
  });
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
  CategoryScreen(secId: widget.section.id,name:widget.section.title) ,));
  });
  } ,
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
  child: Column(
  children: <Widget>[
  Expanded(
  child: Container(
  width: 300,
  height: 200,
  child: CachedNetworkImage(
  fit: BoxFit.cover,
  fadeInCurve: Curves.bounceOut,
  imageUrl: "${widget.section.image}",
  placeholder: (context, url) {
  return Image.asset(
  "assets/images/placeholder.png",
  fit: BoxFit.cover,
  );
  },
  errorWidget: (context, url, error) => Icon(Icons.error),
  ),
  ),
  ),
  Align(
  alignment: Alignment.bottomCenter,
  child: Container(
  // height: 100,
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
  isLoading == false
  ? Container(
  alignment: Alignment.center,
  padding: EdgeInsets.all(5),
  child: setPro.catMainStyle == 0
  ? Container(
  width: 150,
  child: Center(
  child: Text(
  "${widget.section.title}",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.black54,
  fontSize: 14,
  fontFamily: fonts,
  //decoration: TextDecoration.lineThrough,
  fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
  ),
  ),
  )
      : Container(
  width: 90,
  child: Text(
  "${widget.section.title}",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.black54,
  fontSize: 15,
  fontFamily: fonts,
  //decoration: TextDecoration.lineThrough,
  fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
  ),
  ),
  )
      : Container(padding: EdgeInsets.all(6),
  width: 35,
  height: 35,
  child: CircularProgressIndicator(strokeWidth: 1.2,)),
  ],
  ),
  ),
  ),
  ],
  ),
  ),
  ),
  ),
  );}}