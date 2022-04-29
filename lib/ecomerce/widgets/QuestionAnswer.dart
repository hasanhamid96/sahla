import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:provider/provider.dart';

class QuestionAnswer extends StatelessWidget {
  final Product product;

  QuestionAnswer({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                children: product.questions.map((item) {
              return Template(
                question: item.question,
                answer: item.answer,
              );
            }).toList()),
          ),
        ),
      ),
    );
  }
}

class Template extends StatelessWidget {
  const Template({Key key, @required this.question, this.answer})
      : super(key: key);
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.help_outline,
              color: Colors.grey,
            ),
            Container(
              width: 180,
              child: Text(
                question,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.info_outline,
              color: Colors.grey,
            ),
            Container(
              width: 180,
              child: Text(
                answer,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
