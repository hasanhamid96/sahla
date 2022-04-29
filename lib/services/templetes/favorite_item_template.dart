import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/pressedProduct.dart';
import 'package:provider/provider.dart';

class FavoriteItemTemplate extends StatefulWidget {
  final ProductShow product;

  FavoriteItemTemplate({this.product});

  @override
  State<FavoriteItemTemplate> createState() => _FavoriteItemTemplateState();
}

class _FavoriteItemTemplateState extends State<FavoriteItemTemplate> {
  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      print(isLiked);
      Future.delayed(const Duration(milliseconds: 500), () {
        allPro
            .deleteFavorite(widget.product.id, UserProvider.userId)
            .then((value) {
          allPro.changeFavoriteValue(widget.product.index, isLiked);
        });
      });
      return !isLiked;
    }

    return InkWell(
      onTap: () {
        allPro.NavBarShow(false);
        // });
        allPro.fetchDataProduct(widget.product.id);
        AllProviders.isProductSimilarMainOk = false;
        AllProviders.onceSimilar = false;
        AllProviders.isProductOk = false;
        AllProviders.selectedPiece = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PressedProduct(),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Container(
            margin: EdgeInsets.only(bottom: 14),
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Languages.selectedLanguage == 0
                ? Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      widget.product.title,
                                      textAlign: TextAlign.center,
                                      textDirection:
                                          Languages.selectedLanguage == 0
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                LikeButton(
                                  size: 30,
                                  isLiked: widget.product.isFavorite,
                                  onTap: onLikeButtonTapped,
                                  circleColor: CircleColor(
                                      start: Theme.of(context).primaryColor,
                                      end: Theme.of(context).primaryColor),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor:
                                        Theme.of(context).primaryColor,
                                    dotSecondaryColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.withOpacity(0.4),
                                      size: 40,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 120,
                            width: 200,
                            fadeInCurve: Curves.bounceOut,
                            imageUrl: "${widget.product.image}",
                            placeholder: (context, url) {
                              return Image.asset(
                                "assets/images/placeholder.png",
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // FadeInImage(
                          //   placeholder:
                          //       AssetImage('assets/images/placeholder.png'),
                          //   height: 120,
                          //   width: 200,
                          //   image: NetworkImage("${widget.product.image}"),
                          //   fit: BoxFit.cover,
                          // ),
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 120,
                            width: 200,
                            fadeInCurve: Curves.bounceOut,
                            imageUrl: "${widget.product.image}",
                            placeholder: (context, url) {
                              return Image.asset(
                                "assets/images/placeholder.png",
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      widget.product.title,
                                      textAlign: TextAlign.center,
                                      textDirection:
                                          Languages.selectedLanguage == 0
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                LikeButton(
                                  size: 30,
                                  isLiked: widget.product.isFavorite,
                                  onTap: onLikeButtonTapped,
                                  circleColor: CircleColor(
                                      start: Theme.of(context).primaryColor,
                                      end: Theme.of(context).primaryColor),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor:
                                        Theme.of(context).primaryColor,
                                    dotSecondaryColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.withOpacity(0.4),
                                      size: 40,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
      ),
    );
  }
}
