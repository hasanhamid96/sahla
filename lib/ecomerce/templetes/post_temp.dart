
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/news.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/PostPressedScreen.dart';
import 'package:provider/provider.dart';
class PostsHomeTemplate extends StatefulWidget {
  final News news;
  final bool home;
  PostsHomeTemplate({this.news, @required this.home});

  @override
  State<PostsHomeTemplate> createState() => _PostsHomeTemplateState();
}

class _PostsHomeTemplateState extends State<PostsHomeTemplate> {
  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    return InkWell(
      onTap: () {
        setState(() {
          allPro.NavBarShow(false);
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PostPressedScreen(postData: widget.news)));
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),),
        margin: EdgeInsets.all(7),
        child: Hero(
          tag: widget.news.id,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
            child: CachedNetworkImage(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              fit: BoxFit.fill,
              fadeInCurve: Curves.bounceOut,
              imageUrl: "${widget.news.image}",
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/placeholder.png",
                  fit: BoxFit.contain,
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: Languages.selectedLanguage == 0
        //       ? <Widget>[
        //           Flexible(
        //             child: Text(
        //               widget.news.title,
        //               textAlign: TextAlign.right,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //               textDirection: TextDirection.rtl,
        //               style: TextStyle(
        //                   fontSize: 18,
        //                   color: widget.home == true
        //                       ? Colors.black87
        //                       : Colors.blueGrey),
        //             ),
        //           ),
        //           Container(
        //             margin: EdgeInsets.only(left: 10),
        //             child: Hero(
        //               tag: widget.news.id,
        //               child: CachedNetworkImage(
        //                 width: 100,
        //                 fit: BoxFit.fitWidth,
        //                 fadeInCurve: Curves.bounceOut,
        //                 imageUrl: "${widget.news.image}",
        //                 placeholder: (context, url) {
        //                   return Image.asset(
        //                     "assets/images/placeholder.png",
        //                     fit: BoxFit.fitWidth,
        //                   );
        //                 },
        //                 errorWidget: (context, url, error) => Icon(Icons.error),
        //               ),
        //             ),
        //           ),
        //         ]
        //       : <Widget>[
        //           Container(
        //             margin: EdgeInsets.only(right: 10),
        //             child: Hero(
        //               tag: widget.news.id,
        //               child: FadeInImage(
        //                 placeholder:
        //                     AssetImage('assets/images/placeholder.png'),
        //                 width: 100,
        //                 image: NetworkImage("${widget.news.image}"),
        //                 fit: BoxFit.fitWidth,
        //               ),
        //             ),
        //           ),
        //           Flexible(
        //             child: Text(
        //               widget.news.title,
        //               textAlign: TextAlign.left,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //               textDirection: TextDirection.ltr,
        //               style: TextStyle(fontSize: 18, color: Colors.black87),
        //             ),
        //           ),
        //         ],
        // ),
      ),
    );
  }}