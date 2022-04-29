import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/model/SubCat.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:new_sahla/services/templetes/service_item.dart';
import 'package:new_sahla/services/widgets/subCategory.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatefulWidget {
  int secId;
  String name;

  CategoryScreen({Key key, this.secId, this.name}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isLoad = false;

  List<SubCat> subCat = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoad = true;
    Provider.of<Services>(context, listen: false)
        .fetchServicesByCategory(SecId: widget.secId, isSub: false)
        .then((value) {
      setState(() {
        isLoad = false;
        subCat = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
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
        title: Text('${widget.name}'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
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
                : subCat == [] || subCat == null || subCat.isEmpty
                    ? Container()
                    : Container(
                        width: mediaQuery.width * 0.99,
                        height: mediaQuery.height * 0.2,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => DelayedDisplay(
                            slidingBeginOffset: Offset(index.toDouble(), 0),
                            fadingDuration: Duration(milliseconds: 400),
                            child: subCategory(
                              mediaQuery: mediaQuery,
                              category: subCat[index],
                              isSubSub: false,
                            ),
                          ),
                          itemCount: subCat.length,
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
                                width: mediaQuery.width * 0.45,
                                height: mediaQuery.height * 0.4,
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
                : Consumer<Services>(
                    builder: (context, sec, child) => GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sec.serviceItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) => DelayedDisplay(
                              slidingBeginOffset: Offset(index.toDouble(), 0),
                              fadingDuration: Duration(milliseconds: 400),
                              child: ServiceItem(
                                service: sec.serviceItems[index],
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
