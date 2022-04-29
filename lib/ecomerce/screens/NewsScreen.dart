import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/model/news.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/templetes/post_temp.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context, listen: false);
    final allposts = Provider.of<AllProviders>(context, listen: false);
    return Directionality(
      textDirection: Languages.selectedLanguage == 0
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            lang.translation['latestNews'][Languages.selectedLanguage],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: fonts,
                color: Colors.white,
                fontSize: 22),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: allposts.isPostsOk == false
                            ? FutureBuilder(
                                future: allposts.fetchOffersStore(),
                                builder: (ctx, authResultSnap) {
                                  if (authResultSnap.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.black87,
                                      highlightColor: Colors.white,
                                      period: Duration(milliseconds: 700),
                                      child: Column(
                                        children: <Widget>[
                                          for (int i = 0; i < 6; i++)
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                            ),
                                        ],
                                      ),
                                    );
                                  } else if (authResultSnap.hasError) {
                                    print(authResultSnap.error);
                                    return RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          //other.getUserLocation();
                                        });
                                      },
                                      child: Text(
                                          lang.translation['checkInternet']
                                              [Languages.selectedLanguage],
                                          style:
                                              TextStyle(color: Colors.black)),
                                    );
                                  } else {
                                    return Column(
                                        children: allposts.posts.map((item) {
                                      return PostsHomeTemplate(
                                        news: News(
                                          id: item.id,
                                          title: item.title,
                                          text: item.text,
                                          image: item.image,
                                          date: item.date,
                                        ),
                                        home: false,
                                      );
                                    }).toList());
                                  }
                                })
                            : Column(
                                children: allposts.posts.map((item) {
                                return PostsHomeTemplate(
                                  news: News(
                                    id: item.id,
                                    title: item.title,
                                    text: item.text,
                                    image: item.image,
                                    date: item.date,
                                    productId: item.productId,
                                  ),
                                  home: false,
                                );
                              }).toList()),
                      ),
                    ),
                    Divider(),
                    //  : NewsTemplate(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
