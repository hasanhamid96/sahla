import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/services/model/SubCat.dart';
import 'package:new_sahla/services/widgets/sub_category_serv_screen.dart';
import 'package:provider/provider.dart';

class subCategory extends StatelessWidget {
  SubCat category;
  bool isSubSub;

  subCategory(
      {Key key, @required this.mediaQuery, this.category, this.isSubSub: false})
      : super(key: key);
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Provider.of<Shops>(context, listen: false).clearSubShops();
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => SubCategoryScreen(
                  category_id: category.id,
                  parent_id: category.parent_id,
                  catName: category.title,
                  isSubSub: isSubSub)));
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: mediaQuery.width * 0.34,
                decoration: BoxDecoration(shape: BoxShape.rectangle),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  child: CachedNetworkImage(
                    imageUrl: category.image,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.broken_image_outlined),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: mediaQuery.width * 0.34,
              child: Text(
                '${category.title}',
                style: TextStyle(
                    fontSize: 14, color: Colors.black54, fontFamily: fonts),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
