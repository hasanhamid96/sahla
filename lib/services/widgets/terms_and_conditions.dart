import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:provider/provider.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
        title: Text(
          lang.translation['termsAndCondition'][Languages.selectedLanguage],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Text(
    lang.translation['termsAndConditionDESS'][Languages.selectedLanguage],
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
      ),
    ));
  }
}
