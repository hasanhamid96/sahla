import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/widgets/QuestionAnswer.dart';
import 'package:provider/provider.dart';

class ProductInfoPressed extends StatefulWidget {
  final Product product;

  ProductInfoPressed({this.product});

  @override
  State<ProductInfoPressed> createState() => _ProductInfoPressedState();
}

class _ProductInfoPressedState extends State<ProductInfoPressed> {
  bool isExpanded = true;

  bool isExpanded2 = true;

  var dir =
      Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.7,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: GroovinExpansionTile(
                  initiallyExpanded: true,
                  defaultTrailingIconColor: Colors.grey.withOpacity(0.5),
                  trailing: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        lang.translation['clickToSeeMore']
                            [Languages.selectedLanguage],
                        textAlign: TextAlign.right,
                        textDirection: dir,
                        style: Theme.of(context).textTheme.headline1,
                      )),
                  title: Text(''),
                  onExpansionChanged: (value) {
                    setState(() {
                      isExpanded = value;
                    });
                  },
                  inkwellRadius: !isExpanded
                      ? BorderRadius.all(Radius.circular(8.0))
                      : BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                        ),
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              '${widget.product.description}',
                              textDirection: Languages.selectedLanguage == 0
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: fonts),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          widget.product.questions.length >= 1
              ? Divider(
                  endIndent: 40,
                  indent: 40,
                )
              : SizedBox(),
          widget.product.questions.length >= 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Languages.selectedLanguage == 0
                      ? <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 230,
                                            child: GroovinExpansionTile(
                                              initiallyExpanded: false,
                                              trailing: Container(
                                                  //padding: EdgeInsets.only(left:15),
                                                  child: Text(
                                                lang.translation[
                                                        'questionAndAnswers'][
                                                    Languages.selectedLanguage],
                                                textAlign: TextAlign.right,
                                                textDirection: dir,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              )),
                                              defaultTrailingIconColor:
                                                  Colors.grey.withOpacity(0.5),
                                              leading: Icon(
                                                Icons.looks_two,
                                                color: Colors.grey,
                                              ),
                                              title: Text(
                                                "",
                                                textAlign: TextAlign.justify,
                                                textDirection: Languages
                                                            .selectedLanguage ==
                                                        0
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: fonts),
                                              ),
                                              onExpansionChanged: (value) {
                                                setState(() {
                                                  isExpanded2 = value;
                                                });
                                              },
                                              inkwellRadius: !isExpanded2
                                                  ? BorderRadius.all(
                                                      Radius.circular(8.0))
                                                  : BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                    ),
                                              children: <Widget>[
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(5.0),
                                                      bottomRight:
                                                          Radius.circular(5.0),
                                                    ),
                                                    child: QuestionAnswer(
                                                      product: widget.product,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                lang.translation['questionsTitle']
                                    [Languages.selectedLanguage],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: fonts,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ]
                      : <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                lang.translation['questionsTitle']
                                    [Languages.selectedLanguage],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: fonts,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 230,
                                            child: GroovinExpansionTile(
                                              initiallyExpanded: false,
                                              trailing: Container(
                                                  //padding: EdgeInsets.only(left:15),
                                                  child: Text(
                                                lang.translation[
                                                        'questionAndAnswers'][
                                                    Languages.selectedLanguage],
                                                textAlign: TextAlign.right,
                                                textDirection: dir,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              )),
                                              defaultTrailingIconColor:
                                                  Colors.grey.withOpacity(0.5),
                                              leading: Icon(
                                                Icons.looks_two,
                                                color: Colors.grey,
                                              ),
                                              title: Text(
                                                "",
                                                textAlign: TextAlign.justify,
                                                textDirection: Languages
                                                            .selectedLanguage ==
                                                        0
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: fonts),
                                              ),
                                              onExpansionChanged: (value) {
                                                setState(() {
                                                  isExpanded2 = value;
                                                });
                                              },
                                              inkwellRadius: !isExpanded2
                                                  ? BorderRadius.all(
                                                      Radius.circular(8.0))
                                                  : BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                    ),
                                              children: <Widget>[
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(5.0),
                                                      bottomRight:
                                                          Radius.circular(5.0),
                                                    ),
                                                    child: QuestionAnswer(
                                                      product: widget.product,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
