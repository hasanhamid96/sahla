import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductLoading extends StatelessWidget {
  const ShimmerProductLoading({
    Key key,
  }) : super(key: key);
  @override
  Widget build(
      BuildContext context,) {
    return Directionality(
      textDirection: Languages.selectedLanguage == 1
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar(
            //   backgroundColor: Theme.of(context).appBarTheme.color,
            //   centerTitle: true,
            //   title: Text('
            // ),
            Shimmer.fromColors(
                baseColor: Colors.black87,
                highlightColor: Colors.white,
                period: Duration(milliseconds: 700),
                child: Container(
                  //width: MediaQuery.of(context).size.width / 1.1,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 330,
                        decoration: BoxDecoration(
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.1,
                                    // has the effect of extending the shadow
                                    offset: Offset(
                                      0, // horizontal, move right 10
                                      0, // vertical, move down 10
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.1,
                                    // has the effect of extending the shadow
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 280,
                        height: 30,
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 280,
                        height: 30,
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 580,
                        height: 150,
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
                )),
          ],
        ),
      ),
    );}}

