import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/model/Service.dart';
import 'package:new_sahla/services/model/SubCat.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:new_sahla/services/templetes/service_item.dart';
import 'package:new_sahla/services/widgets/subCategory.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryScreen extends StatefulWidget {
  int category_id;
  int parent_id;
  String catName;
  bool isSubSub;

  SubCategoryScreen(
      {Key key,
      this.category_id,
      this.parent_id,
      this.catName,
      this.isSubSub: false})
      : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoad = false;

  List<SubCat> orginalItem = [];

  List<Service> loadedAllServices = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoad = true;

    Provider.of<Services>(context, listen: false)
            .fetchServicesBySubCategory(
                SecId: widget.category_id, parent_id: widget.parent_id)
            .then((value) {
      setState(() {
        orginalItem = value;
        isLoad = false;
      });
    })
        // Provider.of<Services>(context, listen: false)
        //     .fetchServicesByCategory(SecId: widget.category_id, isSub: true)
        //     .then((value) {
        //   setState(() {
        //     isLoad = false;
        //     if(value.isNotEmpty)
        //     orginalItem = value;
        //   });
        // })
        ;
    // if(widget.isSubSub) {
    //   Provider.of<Services>(context, listen: false)
    //       .fetchServicesBySubCategory(SecId: widget.category_id, )
    //       .then((value) {
    //     setState(() {
    //       isLoad = false;
    //       orginalItem = value;
    //     });
    //   });
    // }
    // else{
    //   Provider.of<Services>(context, listen: false)
    //       .fetchServicesByCategory(SecId: widget.category_id, isSub: true)
    //       .then((value) {
    //     setState(() {
    //       isLoad = false;
    //       orginalItem = value;
    //     });
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
        title: Text('${widget.catName}'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // if(!widget.isSubSub)
            isLoad
                ? SingleChildScrollView(
                    child: Container(
                      width: mediaQuery.width * 0.99,
                      height: mediaQuery.height * 0.17,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < 10; i++)
                              Card(
                                color: Colors.grey[300],
                                child: Container(
                                  width: mediaQuery.width * 0.30,
                                  height: mediaQuery.height * 0.3,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: mediaQuery.width * 0.99,
                    height: orginalItem == null || orginalItem.length == 0
                        ? 0
                        : mediaQuery.height * 0.2,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => subCategory(
                        mediaQuery: mediaQuery,
                        category: orginalItem[index],
                        isSubSub: true,
                      ),
                      itemCount: orginalItem.length,
                    ),
                  ),
            isLoad
                ? Shimmer.fromColors(
                    baseColor: Colors.black87,
                    highlightColor: Colors.white,
                    period: Duration(milliseconds: 700),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      width: mediaQuery.width,
                      height: mediaQuery.height,
                      child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          children: [
                            for (int i = 0; i < 6; i++)
                              Container(
                                margin: EdgeInsets.all(8),
                                width: mediaQuery.width * 0.4,
                                height: mediaQuery.height * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
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
                          ]),
                    ),
                  )
                : widget.parent_id != null
                    ? Consumer<Services>(
                        builder: (context, sec, child) => sec
                                    .subSubServiceItems.length ==
                                0
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: mediaQuery.height * 0.4),
                                  child: Text(
                                    Languages.selectedLanguage == 0
                                        ? "لا توجد خدمات"
                                        : 'no services',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: sec.subSubServiceItems.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.75,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                itemBuilder: (context, index) => DelayedDisplay(
                                      slidingBeginOffset:
                                          Offset(index.toDouble(), 0),
                                      fadingDuration:
                                          Duration(milliseconds: 400),
                                      child: ServiceItem(
                                        service: sec.subSubServiceItems[index],
                                        mediaQuery: mediaQuery,
                                      ),
                                    )),
                      )
                    : Consumer<Services>(
                        builder: (context, sec, child) => sec
                                    .subServiceItems.length ==
                                0
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQuery.height * 0.4),
                                child: Text(
                                  Languages.selectedLanguage == 0
                                      ? "لا توجد خدمات"
                                      : 'no services',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: sec.subServiceItems.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.75,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                itemBuilder: (context, index) => DelayedDisplay(
                                      slidingBeginOffset:
                                          Offset(index.toDouble(), 0),
                                      fadingDuration:
                                          Duration(milliseconds: 400),
                                      child: ServiceItem(
                                        service: sec.subServiceItems[index],
                                        mediaQuery: mediaQuery,
                                      ),
                                    )),
                      ),
          ],
        ),
      ),
    );
  }
}
