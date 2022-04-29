import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'ProductMainTemplate.dart';

class SimilarItems extends StatefulWidget {
  final Product product;

  SimilarItems({this.product});

  @override
  State<SimilarItems> createState() => _SimilarItemsState();
}

class _SimilarItemsState extends State<SimilarItems> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final allposts = Provider.of<AllProviders>(context, listen: false);
    allposts.fetchDataAllProductsOnSimilar(
        widget.product.catType, widget.product.catId);
  }

  @override
  Widget build(BuildContext context) {
    final allposts = Provider.of<AllProviders>(context, listen: false);
    return Center(
      child: Consumer<AllProviders>(
        builder: (ctx, pro, _) {
          if (pro.isProdSimilar == false) {
            return Shimmer.fromColors(
                baseColor: Colors.black87,
                highlightColor: Colors.white,
                period: Duration(milliseconds: 700),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
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
                          Container(
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
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
                    ],
                  ),
                ));
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: allposts.allProductsSimilar.length,
                  itemBuilder: (context, index) {
                    var item = allposts.allProductsSimilar[index];
                    return ProductMainTemplate(
                      product: ProductShow(
                        id: item.id,
                        title: item.title,
                        description: item.description,
                        price: item.price,
                        discount: item.discount,
                        image: item.image,
                        discountPercentage: item.discountPercentage,
                        isFavorite: item.isFavorite,
                        index: item.index,
                      ),
                      isMain: false,
                    );
                    // return SingleChildScrollView(
                    //   reverse: true,
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: allposts.allProductsSimilar.map((item) {
                    //       return Row(
                    //         children: <Widget>[
                    //           Container(
                    //             height: MediaQuery.of(context).size.height*0.3,
                    //             width: 160,
                    //             child: ProductMainTemplate(
                    //               product: ProductShow(
                    //                 id: item.id,
                    //                 title: item.title,
                    //                 description: item.description,
                    //                 price: item.price,
                    //                 discount: item.discount,
                    //                 image: item.image,
                    //                 discountPercentage: item.discountPercentage,
                    //                 isFavorite: item.isFavorite,
                    //                 index: item.index,
                    //               ),
                    //               isMain: false,
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //         ],
                    //       );
                    //     }).toList(),
                    //   ),
                    // );
                  }),
            );
          }
        },
      ),
    );
  }
}
